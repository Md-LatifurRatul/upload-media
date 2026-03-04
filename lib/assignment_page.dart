import 'dart:async';

import 'package:assignments/constants/app_colors.dart';
import 'package:assignments/custom_assignment_button_state.dart';
import 'package:assignments/models/upload_file_model.dart';
import 'package:assignments/utils/app_snackbar.dart';
import 'package:assignments/widgets/instructions_card.dart';
import 'package:assignments/widgets/points_status_row.dart';
import 'package:assignments/widgets/question_card.dart';
import 'package:assignments/widgets/upload_actions_bar.dart';
import 'package:assignments/widgets/upload_area.dart';
import 'package:assignments/widgets/upload_file_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final List<UploadFileModel> _files = [];
  final Map<String, Timer> _uploadTimers = {};

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Lifecycle
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  @override
  void dispose() {
    for (final timer in _uploadTimers.values) {
      timer.cancel();
    }
    for (final file in _files) {
      file.dispose();
    }
    super.dispose();
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // File picking
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: UploadFileModel.allowedExtensions,
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return;
    if (!mounted) return;

    final List<UploadFileModel> validFiles = [];

    for (final picked in result.files) {
      final size = picked.size;

      if (size > UploadFileModel.maxSizeBytes) {
        if (mounted) {
          showAppSnackbar(
            context,
            '${picked.name} exceeds 10 MB limit',
            type: SnackbarType.error,
          );
        }
        continue;
      }

      final ext = picked.extension ?? '';
      validFiles.add(
        UploadFileModel(
          name: picked.name,
          extension: ext,
          sizeInBytes: size,
          path: picked.path ?? '',
        ),
      );
    }

    if (validFiles.isEmpty) return;

    setState(() => _files.addAll(validFiles));

    for (final file in validFiles) {
      _startUpload(file);
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Upload simulation
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  void _startUpload(UploadFileModel file) {
    _uploadTimers[file.id]?.cancel();

    file.status.value = UploadStatus.uploading;
    file.progress.value = 0;

    final totalMs = (file.totalUploadSeconds * 1000).round();
    const tickMs = 100;
    final increment = tickMs / totalMs;

    _uploadTimers[file.id] = Timer.periodic(
      const Duration(milliseconds: tickMs),
      (timer) {
        final next = file.progress.value + increment;
        if (next >= 1.0) {
          file.progress.value = 1.0;
          file.status.value = UploadStatus.success;
          timer.cancel();
          _uploadTimers.remove(file.id);
          if (mounted) setState(() {});
          _checkAllComplete();
        } else {
          file.progress.value = next;
        }
      },
    );
  }

  void _checkAllComplete() {
    if (_files.isEmpty) return;
    final allDone = _files.every((f) => f.status.value == UploadStatus.success);
    if (allDone && mounted) {
      showAppSnackbar(
        context,
        'All files uploaded successfully',
        type: SnackbarType.success,
      );
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Actions
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  void _cancelUpload(UploadFileModel file) {
    _uploadTimers[file.id]?.cancel();
    _uploadTimers.remove(file.id);
    file.dispose();
    setState(() => _files.remove(file));
  }

  void _retryUpload(UploadFileModel file) {
    _startUpload(file);
  }

  void _deleteFile(UploadFileModel file) {
    _uploadTimers[file.id]?.cancel();
    _uploadTimers.remove(file.id);
    file.dispose();
    setState(() => _files.remove(file));
  }

  void _uploadAll() {
    final failedFiles = _files.where(
      (f) => f.status.value == UploadStatus.failed,
    );

    if (failedFiles.isEmpty) {
      _pickFiles();
      return;
    }

    for (final file in failedFiles) {
      _startUpload(file);
    }
  }

  void _clearAll() {
    for (final timer in _uploadTimers.values) {
      timer.cancel();
    }
    _uploadTimers.clear();
    for (final file in _files) {
      file.dispose();
    }
    setState(() => _files.clear());
    showAppSnackbar(context, 'All files cleared', type: SnackbarType.info);
  }

  Future<void> _submitAssignment() async {
    if (_files.isEmpty) {
      showAppSnackbar(
        context,
        'Please upload at least one file',
        type: SnackbarType.error,
      );
      return;
    }

    final hasUploading = _files.any(
      (f) => f.status.value == UploadStatus.uploading,
    );
    if (hasUploading) {
      showAppSnackbar(
        context,
        'Please wait for uploads to complete',
        type: SnackbarType.error,
      );
      return;
    }

    final hasFailed = _files.any((f) => f.status.value == UploadStatus.failed);
    if (hasFailed) {
      showAppSnackbar(
        context,
        'Please retry or remove failed uploads',
        type: SnackbarType.error,
      );
      return;
    }

    // ── Real API call (uncomment when backend is ready) ──────────────
    // try {
    //   final uri = Uri.parse('https://your-api.com/api/assignments/submit');
    //   final request = http.MultipartRequest('POST', uri);
    //
    //   // Add auth header
    //   // request.headers['Authorization'] = 'Bearer $token';
    //
    //   // Attach each file
    //   for (final file in _files) {
    //     request.files.add(
    //       await http.MultipartFile.fromPath('files', file.path),
    //     );
    //   }
    //
    //   final response = await request.send();
    //
    //   if (!mounted) return;
    //
    //   if (response.statusCode == 200) {
    //     _cleanUpAndClear();
    //     showAppSnackbar(
    //       context,
    //       'Assignment submitted successfully!',
    //       type: SnackbarType.success,
    //     );
    //   } else {
    //     showAppSnackbar(
    //       context,
    //       'Submission failed. Please try again.',
    //       type: SnackbarType.error,
    //     );
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     showAppSnackbar(
    //       context,
    //       'Network error. Please check your connection.',
    //       type: SnackbarType.error,
    //     );
    //   }
    // }
    // ─────────────────────────────────────────────────────────────────

    // Testing: simulate successful submission
    _cleanUpAndClear();
    showAppSnackbar(
      context,
      'Assignment submitted successfully!',
      type: SnackbarType.success,
    );
  }

  void _cleanUpAndClear() {
    for (final timer in _uploadTimers.values) {
      timer.cancel();
    }
    _uploadTimers.clear();
    for (final file in _files) {
      file.dispose();
    }
    setState(() => _files.clear());
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Helpers
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ButtonState get _submitButtonState {
    if (_files.isEmpty) return ButtonState.disabled;
    final anyUploading = _files.any(
      (f) => f.status.value == UploadStatus.uploading,
    );
    if (anyUploading) return ButtonState.disabled;
    return ButtonState.pressed;
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Build
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final hPadding = isWide ? 24.0 : 16.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leadingWidth: 40,
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primaryBlue,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 4,
          title: const Text(
            'Assignment 2',
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            // ── Blue accent line ────────────────────────────────────
            Container(
              height: 1.5,
              color: AppColors.primaryBlue.withValues(alpha: 0.25),
            ),

            // ── Scrollable content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPadding),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          const PointsStatusRow(),
                          const SizedBox(height: 20),
                          const InstructionsCard(),
                          const SizedBox(height: 13),
                          const QuestionCard(),
                          const SizedBox(height: 13),
                          _uploadCard(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Fixed submit button ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: CustomAssignmentButtonState(
                    text: 'Submit Assignment',
                    state: _submitButtonState,
                    onPressed: _submitAssignment,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Upload card (the only section that rebuilds on list changes) ──

  Widget _uploadCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF0), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload your Answer',
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          UploadArea(onTap: _pickFiles),

          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),

          if (_files.isNotEmpty) ...[
            const SizedBox(height: 16),
            for (int i = 0; i < _files.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              UploadFileTile(
                key: ValueKey(_files[i].id),
                file: _files[i],
                onCancel: () => _cancelUpload(_files[i]),
                onRetry: () => _retryUpload(_files[i]),
                onDelete: () => _deleteFile(_files[i]),
              ),
            ],
          ],

          const SizedBox(height: 20),
          UploadActionsBar(
            hasFiles: _files.isNotEmpty,
            onClearAll: _clearAll,
            onUploadAll: _uploadAll,
          ),
        ],
      ),
    );
  }
}
