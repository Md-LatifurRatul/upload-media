import 'package:flutter/material.dart';
import 'package:assignments/constants/app_colors.dart';

enum SnackbarType { success, error, info }

void showAppSnackbar(
  BuildContext context,
  String message, {
  SnackbarType type = SnackbarType.info,
}) {
  final Color bgColor;
  final IconData icon;

  switch (type) {
    case SnackbarType.success:
      bgColor = AppColors.successGreen;
      icon = Icons.check_circle_outline;
    case SnackbarType.error:
      bgColor = AppColors.errorRed;
      icon = Icons.error_outline;
    case SnackbarType.info:
      bgColor = AppColors.primaryBlue;
      icon = Icons.info_outline;
  }

  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
      ),
    );
}
