import 'package:flutter/material.dart';
import 'package:assignments/constants/app_colors.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 28,
    this.iconSize = 16,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.greyText.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(icon, size: iconSize, color: AppColors.greyText),
      ),
    );
  }
}
