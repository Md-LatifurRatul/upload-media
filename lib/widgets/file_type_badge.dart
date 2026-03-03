import 'package:flutter/material.dart';
import 'package:assignments/constants/app_colors.dart';

class FileTypeBadge extends StatelessWidget {
  const FileTypeBadge({super.key, required this.extension});

  final String extension;

  @override
  Widget build(BuildContext context) {
    final Color badgeColor;
    switch (extension.toLowerCase()) {
      case 'jpg' || 'jpeg' || 'png' || 'heic':
        badgeColor = AppColors.primaryBlue;
      case 'pdf':
        badgeColor = AppColors.errorRed;
      default:
        badgeColor = AppColors.greyText;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          extension.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
