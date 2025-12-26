import 'package:flutter/material.dart';

/// ZinapsPay Color Palette - Matching Next.js Tailwind configuration
class AppColors {
  AppColors._();

  // Primary Colors - Dark Theme (Default)
  static const Color jetBlack = Color(0xFF000000);
  static const Color charcoal = Color(0xFF0A0A0A);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color silver = Color(0xFFF5F5F7);
  static const Color silverGray = Color(0xFFE8E8ED);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Legacy/Semantic Colors
  static const Color background = Color(0xFF000000);
  static const Color foreground = Color(0xFFFFFFFF);
  static const Color card = Color(0xFF111111);
  static const Color cardForeground = Color(0xFFFFFFFF);
  static const Color popover = Color(0xFF111111);
  static const Color popoverForeground = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFFFFFFFF);
  static const Color primaryForeground = Color(0xFF000000);
  static const Color secondary = Color(0xFF1F1F1F);
  static const Color secondaryForeground = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF1F1F1F);
  static const Color mutedForeground = Color(0xFFA1A1AA);
  static const Color accent = Color(0xFF1F1F1F);
  static const Color accentForeground = Color(0xFFFFFFFF);
  static const Color destructive = Color(0xFFEF4444);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color border = Color(0xFF27272A);
  static const Color input = Color(0xFF27272A);
  static const Color ring = Color(0xFFD4D4D8);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF000000);
  static const Color gradientMid = Color(0xFF0A0A0A);
  static const Color gradientEnd = Color(0xFF000000);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightForeground = Color(0xFF1A1A1A);
  static const Color lightCard = Color(0xFFF8F9FA);
  static const Color lightCardForeground = Color(0xFF1A1A1A);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightMuted = Color(0xFFF5F5F7);
  static const Color lightMutedForeground = Color(0xFF666666);

  // Opacity values
  static const double opacityPrimary = 1.0;
  static const double opacitySecondary = 0.7;
  static const double opacityTertiary = 0.4;
  static const double opacityDisabled = 0.5;
  static const double opacityHover = 0.1;
  static const double opacityBorder = 0.1;
  static const double opacityGlass = 0.05;

  // Gradient definitions
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [jetBlack, charcoal, jetBlack],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [jetBlack, darkGray],
  );

  static const LinearGradient shineGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [jetBlack, darkGray, charcoal, darkGray, jetBlack],
  );

  // Light theme gradients
  static const LinearGradient lightMainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pureWhite, lightCard, Color(0xFFFFFAFA)],
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pureWhite, lightCard],
  );
}
