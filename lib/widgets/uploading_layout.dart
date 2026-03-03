import 'package:assignments/constants/app_colors.dart';
import 'package:assignments/models/upload_file_model.dart';
import 'package:assignments/widgets/circle_icon_button.dart';
import 'package:assignments/widgets/file_type_badge.dart';
import 'package:flutter/material.dart';

class UploadingLayout extends StatelessWidget {
  const UploadingLayout({
    super.key,
    required this.file,
    required this.onCancel,
  });

  final UploadFileModel file;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FileTypeBadge(extension: file.extension),
            const SizedBox(width: 12),
            Expanded(
              child: ValueListenableBuilder<double>(
                valueListenable: file.progress,
                builder: (context, progress, _) {
                  final percentage = (progress * 100).round();
                  final timeLeft = file.estimatedTimeLeft(progress);
                  return Column(
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
                      Text(
                        '${file.formattedSize} \u2022 $timeLeft',
                        style: const TextStyle(
                          color: AppColors.greyText,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: AppColors.lightGrey,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryBlue,
                                ),
                                minHeight: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 36,
                            child: Text(
                              '$percentage%',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: AppColors.darkText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            CircleIconButton(icon: Icons.close, onPressed: onCancel),
          ],
        ),
      ],
    );
  }
}
