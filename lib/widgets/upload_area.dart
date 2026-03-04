import 'package:assignments/constants/app_colors.dart';
import 'package:assignments/widgets/dashed_border_painter.dart';
import 'package:flutter/material.dart';

class UploadArea extends StatelessWidget {
  const UploadArea({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: CustomPaint(
        painter: const DashedBorderPainter(
          color: Color(0xFFD0D5DD),
          strokeWidth: 1,
          dashWidth: 6,
          dashGap: 4,
          radius: 10,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 36,
                  color: AppColors.greyText.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 8),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Click here',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryBlue,
                        ),
                      ),
                      TextSpan(
                        text: ' to upload',
                        style: TextStyle(
                          color: AppColors.darkText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'File Type: pdf, png, jpeg, heic. Max Size: 10 Mb',
                  style: TextStyle(color: AppColors.greyText, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
