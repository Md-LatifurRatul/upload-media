import 'package:flutter/material.dart';
import 'package:assignments/constants/app_colors.dart';

class ActionIconButton extends StatelessWidget {
  const ActionIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 20,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: size, color: color ?? AppColors.greyText),
      ),
    );
  }
}
