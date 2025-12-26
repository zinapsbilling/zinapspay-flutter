import 'package:flutter/material.dart';

/// Application size constants for consistent spacing and sizing
class AppSizes {
  AppSizes._();

  // Spacing
  static const double spacing0 = 0;
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing56 = 56;
  static const double spacing64 = 64;

  // Padding
  static const EdgeInsets paddingXS = EdgeInsets.all(4);
  static const EdgeInsets paddingS = EdgeInsets.all(8);
  static const EdgeInsets paddingM = EdgeInsets.all(16);
  static const EdgeInsets paddingL = EdgeInsets.all(24);
  static const EdgeInsets paddingXL = EdgeInsets.all(32);
  static const EdgeInsets paddingXXL = EdgeInsets.all(48);

  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: 24);

  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: 24);

  // Border Radius
  static const double radiusXS = 4;
  static const double radiusS = 6;
  static const double radiusM = 8;
  static const double radiusL = 12;
  static const double radiusXL = 16;
  static const double radiusXXL = 24;
  static const double radiusRound = 9999;

  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusS = BorderRadius.all(Radius.circular(radiusS));
  static const BorderRadius borderRadiusM = BorderRadius.all(Radius.circular(radiusM));
  static const BorderRadius borderRadiusL = BorderRadius.all(Radius.circular(radiusL));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusXXL = BorderRadius.all(Radius.circular(radiusXXL));
  static const BorderRadius borderRadiusRound = BorderRadius.all(Radius.circular(radiusRound));

  // Icon Sizes
  static const double iconXS = 12;
  static const double iconS = 16;
  static const double iconM = 20;
  static const double iconL = 24;
  static const double iconXL = 32;
  static const double iconXXL = 48;

  // Font Sizes
  static const double fontXS = 10;
  static const double fontS = 12;
  static const double fontM = 14;
  static const double fontL = 16;
  static const double fontXL = 18;
  static const double fontXXL = 20;
  static const double fontTitle = 24;
  static const double fontHeading = 32;
  static const double fontDisplay = 48;

  // Sidebar
  static const double sidebarCollapsed = 80;
  static const double sidebarExpanded = 320;

  // Touch Targets (Apple's 44px minimum)
  static const double touchTarget = 44;
  static const double touchTargetMobile = 48;

  // Card
  static const double cardMinHeight = 100;
  static const double cardMaxWidth = 600;

  // Button
  static const double buttonHeight = 44;
  static const double buttonHeightSmall = 36;
  static const double buttonHeightLarge = 52;

  // Input
  static const double inputHeight = 48;
  static const double inputHeightSmall = 40;

  // Avatar
  static const double avatarS = 32;
  static const double avatarM = 40;
  static const double avatarL = 48;
  static const double avatarXL = 64;

  // Breakpoints (matching responsive_framework)
  static const double breakpointMobile = 450;
  static const double breakpointTablet = 800;
  static const double breakpointDesktop = 1200;
  static const double breakpointLargeDesktop = 1600;

  // Elevation
  static const double elevationNone = 0;
  static const double elevationXS = 1;
  static const double elevationS = 2;
  static const double elevationM = 4;
  static const double elevationL = 8;
  static const double elevationXL = 16;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);
}
