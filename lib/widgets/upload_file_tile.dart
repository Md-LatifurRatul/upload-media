import 'package:assignments/models/upload_file_model.dart';
import 'package:assignments/widgets/failed_layout.dart';
import 'package:assignments/widgets/success_layout.dart';
import 'package:assignments/widgets/uploading_layout.dart';
import 'package:flutter/material.dart';

/// Displays a single file with its upload status.
///
/// Uses [ValueListenableBuilder] so that progress ticks (every 100 ms)
/// only rebuild the progress bar + percentage text — not the entire page.
class UploadFileTile extends StatelessWidget {
  const UploadFileTile({
    super.key,
    required this.file,
    required this.onCancel,
    required this.onRetry,
    required this.onDelete,
  });

  final UploadFileModel file;
  final VoidCallback onCancel;
  final VoidCallback onRetry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ValueListenableBuilder<UploadStatus>(
        valueListenable: file.status,
        builder: (context, status, _) {
          return switch (status) {
            UploadStatus.uploading => UploadingLayout(
              file: file,
              onCancel: onCancel,
            ),
            UploadStatus.failed => FailedLayout(
              file: file,
              onRetry: onRetry,
              onDelete: onDelete,
            ),
            UploadStatus.success => SuccessLayout(
              file: file,
              onDelete: onDelete,
            ),
          };
        },
      ),
    );
  }
}
