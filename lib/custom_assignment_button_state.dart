import 'package:flutter/material.dart';

enum ButtonState {
  disabled,
  pressed, // Active state (gradient)
  hover, // Hover/Focused state (brighter gradient)
}

class CustomAssignmentButtonState extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonState state;
  final double? height;
  final double? borderRadius;

  const CustomAssignmentButtonState({
    super.key,
    required this.text,
    this.onPressed,
    this.state = ButtonState.pressed,
    this.height,
    this.borderRadius,
  });

  // Active gradient
  static const Color _activeStart = Color(0xFF0037FF);
  static const Color _activeEnd = Color(0xFF009EFF);

  // Disabled: darkest version of the same gradient
  static const Color _disabledStart = Color(0xFF001A4D);
  static const Color _disabledEnd = Color(0xFF00436B);

  // Hover: slightly brighter
  static const Color _hoverStart = Color(0xFF1A56C4);
  static const Color _hoverEnd = Color(0xFF4294F0);

  @override
  Widget build(BuildContext context) {
    final isEnabled = state != ButtonState.disabled;
    final radius = borderRadius ?? 12.0;
    final btnHeight = height ?? 51.0;

    final List<Color> gradientColors = switch (state) {
      ButtonState.disabled => [_disabledStart, _disabledEnd],
      ButtonState.pressed => [_activeStart, _activeEnd],
      ButtonState.hover => [_hoverStart, _hoverEnd],
    };

    return SizedBox(
      width: double.infinity,
      height: btnHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? (onPressed ?? () {}) : null,
            borderRadius: BorderRadius.circular(radius),
            splashColor: Colors.white.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
