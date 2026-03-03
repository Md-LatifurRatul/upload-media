import 'package:assignments/constants/app_colors.dart';
import 'package:flutter/material.dart';

class UploadActionsBar extends StatelessWidget {
  const UploadActionsBar({
    super.key,
    required this.onClearAll,
    required this.onUploadAll,
    this.hasFiles = false,
  });

  final VoidCallback onClearAll;
  final VoidCallback onUploadAll;
  final bool hasFiles;

  static const Color _gradientStart = Color(0xFF0037FF);
  static const Color _gradientEnd = Color(0xFF009EFF);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.help_outline_rounded,
          size: 18,
          color: AppColors.greyText,
        ),
        const SizedBox(width: 4),
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Help Center',
            style: TextStyle(color: AppColors.greyText, fontSize: 13),
          ),
        ),
        const Spacer(),

        // ── Clear All ──
        GestureDetector(
          onTap: hasFiles ? onClearAll : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.96,
              vertical: 6.48,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3.24),
              border: Border.all(color: const Color(0xFFEAECEF), width: 0.81),
            ),
            child: Text(
              'Clear All',
              style: TextStyle(
                color: hasFiles ? AppColors.greyText : AppColors.greyText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ── Upload All (gradient) ──
        GestureDetector(
          onTap: onUploadAll,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_gradientStart, _gradientEnd],
              ),
              borderRadius: BorderRadius.circular(3.24),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Upload All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
