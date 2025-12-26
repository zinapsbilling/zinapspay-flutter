import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Gradient background matching the Next.js jet-black-surface class
class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool useLightTheme;

  const GradientBackground({
    super.key,
    required this.child,
    this.useLightTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: useLightTheme
            ? AppColors.lightMainGradient
            : AppColors.mainGradient,
      ),
      child: child,
    );
  }
}
