import 'package:assignments/constants/app_colors.dart';
import 'package:assignments/models/upload_file_model.dart';
import 'package:assignments/widgets/action_icon_button.dart';
import 'package:assignments/widgets/file_type_badge.dart';
import 'package:flutter/material.dart';

class FailedLayout extends StatelessWidget {
  const FailedLayout({
    super.key,
    required this.file,
    required this.onRetry,
    required this.onDelete,
  });

  final UploadFileModel file;
  final VoidCallback onRetry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FileTypeBadge(extension: file.extension),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.name,
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              const Text(
                'Upload failed',
                style: TextStyle(color: AppColors.errorRed, fontSize: 12),
              ),
            ],
          ),
        ),
        ActionIconButton(icon: Icons.refresh, onPressed: onRetry),
        const SizedBox(width: 4),
        ActionIconButton(icon: Icons.delete_outline, onPressed: onDelete),
      ],
    );
  }
}
