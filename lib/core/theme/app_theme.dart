import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  // Dark Theme (Default)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.primaryForeground,
        secondary: AppColors.secondary,
        onSecondary: AppColors.secondaryForeground,
        surface: AppColors.card,
        onSurface: AppColors.cardForeground,
        error: AppColors.destructive,
        onError: AppColors.destructiveForeground,
        outline: AppColors.border,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppColors.foreground),
        titleTextStyle: TextStyle(
          color: AppColors.foreground,
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadiusL,
          side: BorderSide(
            color: AppColors.border.withOpacity(0.1),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.input.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing12,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: BorderSide(color: AppColors.ring.withOpacity(0.4)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: const BorderSide(color: AppColors.destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: const BorderSide(color: AppColors.destructive, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.foreground.withOpacity(0.7)),
        hintStyle: TextStyle(color: AppColors.foreground.withOpacity(0.4)),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing24,
            vertical: AppSizes.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.borderRadiusM,
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: AppSizes.fontL,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.foreground,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing24,
            vertical: AppSizes.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.borderRadiusM,
          ),
          side: BorderSide(color: AppColors.border.withOpacity(0.3)),
          textStyle: const TextStyle(
            fontSize: AppSizes.fontL,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.foreground,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing16,
            vertical: AppSizes.spacing8,
          ),
          textStyle: const TextStyle(
            fontSize: AppSizes.fontM,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.foreground,
        size: AppSizes.iconL,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppSizes.fontDisplay,
          fontWeight: FontWeight.w700,
          color: AppColors.foreground,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: AppSizes.fontHeading,
          fontWeight: FontWeight.w700,
          color: AppColors.foreground,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: AppSizes.fontTitle,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
        headlineLarge: TextStyle(
          fontSize: AppSizes.fontXXL,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
        headlineMedium: TextStyle(
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
        headlineSmall: TextStyle(
          fontSize: AppSizes.fontL,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
        titleLarge: TextStyle(
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground,
        ),
        titleMedium: TextStyle(
          fontSize: AppSizes.fontL,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground,
        ),
        titleSmall: TextStyle(
          fontSize: AppSizes.fontM,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground,
        ),
        bodyLarge: TextStyle(
          fontSize: AppSizes.fontL,
          fontWeight: FontWeight.w400,
          color: AppColors.foreground,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.fontM,
          fontWeight: FontWeight.w400,
          color: AppColors.foreground,
        ),
        bodySmall: TextStyle(
          fontSize: AppSizes.fontS,
          fontWeight: FontWeight.w400,
          color: AppColors.mutedForeground,
        ),
        labelLarge: TextStyle(
          fontSize: AppSizes.fontM,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground,
        ),
        labelMedium: TextStyle(
          fontSize: AppSizes.fontS,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground,
        ),
        labelSmall: TextStyle(
          fontSize: AppSizes.fontXS,
          fontWeight: FontWeight.w500,
          color: AppColors.mutedForeground,
          letterSpacing: 0.5,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.border.withOpacity(0.1),
        thickness: 1,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadiusXL,
        ),
        elevation: 24,
      ),
// Popup Menu Theme (for Syncfusion filter popups)      popupMenuTheme: PopupMenuThemeData(        color: const Color(0xFF1A1A1A),        elevation: 8,        shape: RoundedRectangleBorder(          borderRadius: AppSizes.borderRadiusM,          side: BorderSide(color: Colors.white.withOpacity(0.1)),        ),        textStyle: const TextStyle(color: Colors.white),      ),      // Checkbox Theme (for filter checkboxes)      checkboxTheme: CheckboxThemeData(        fillColor: WidgetStateProperty.resolveWith((states) {          if (states.contains(WidgetState.selected)) {            return Colors.white;          }          return Colors.transparent;        }),        checkColor: WidgetStateProperty.all(const Color(0xFF1A1A1A)),        side: BorderSide(color: Colors.white.withOpacity(0.5)),        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),      ),      // List Tile Theme (for filter options)      listTileTheme: ListTileThemeData(        tileColor: Colors.transparent,        textColor: Colors.white,        iconColor: Colors.white.withOpacity(0.7),        selectedTileColor: Colors.white.withOpacity(0.1),        selectedColor: Colors.white,      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXL),
          ),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.card,
        contentTextStyle: const TextStyle(color: AppColors.foreground),
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadiusM,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondary,
        labelStyle: const TextStyle(color: AppColors.foreground),
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadiusRound,
        ),
        side: BorderSide.none,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.foreground,
        unselectedLabelColor: AppColors.mutedForeground,
        indicatorColor: AppColors.foreground,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: AppSizes.fontM,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: AppSizes.fontM,
        ),
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.secondary,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: AppSizes.fontS, fontWeight: FontWeight.w500),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.foreground,
        linearTrackColor: AppColors.secondary,
      ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightForeground,
        onPrimary: AppColors.lightBackground,
        secondary: AppColors.lightMuted,
        onSecondary: AppColors.lightForeground,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightCardForeground,
        error: AppColors.destructive,
        onError: AppColors.destructiveForeground,
        outline: AppColors.lightBorder,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: AppColors.lightForeground),
        titleTextStyle: TextStyle(
          color: AppColors.lightForeground,
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadiusL,
          side: const BorderSide(
            color: AppColors.lightBorder,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing12,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: BorderSide(color: AppColors.lightForeground.withOpacity(0.4)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: const BorderSide(color: AppColors.destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadiusM,
          borderSide: const BorderSide(color: AppColors.destructive, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.lightForeground.withOpacity(0.7)),
        hintStyle: TextStyle(color: AppColors.lightForeground.withOpacity(0.4)),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightForeground,
          foregroundColor: AppColors.lightBackground,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing24,
            vertical: AppSizes.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.borderRadiusM,
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: AppSizes.fontL,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Text Theme (Light)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppSizes.fontDisplay,
          fontWeight: FontWeight.w700,
          color: AppColors.lightForeground,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: AppSizes.fontHeading,
          fontWeight: FontWeight.w700,
          color: AppColors.lightForeground,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: AppSizes.fontTitle,
          fontWeight: FontWeight.w600,
          color: AppColors.lightForeground,
        ),
        headlineLarge: TextStyle(
          fontSize: AppSizes.fontXXL,
          fontWeight: FontWeight.w600,
          color: AppColors.lightForeground,
        ),
        headlineMedium: TextStyle(
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.w600,
          color: AppColors.lightForeground,
        ),
        headlineSmall: TextStyle(
          fontSize: AppSizes.fontL,
          fontWeight: FontWeight.w600,
          color: AppColors.lightForeground,
        ),
        titleLarge: TextStyle(
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.w500,
          color: AppColors.lightForeground,
        ),
        titleMedium: TextStyle(
          fontSize: AppSizes.fontL,
          fontWeight: FontWeight.w500,
          color: AppColors.lightForeground,
        ),
        titleSmall: TextStyle(
          fontSize: AppSizes.fontM,
          fontWeight: FontWeight.w500,
          color: AppColors.lightForeground,
        ),
        bodyLarge: TextStyle(
          fontSize: AppSizes.fontL,
          fontWeight: FontWeight.w400,
          color: AppColors.lightForeground,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.fontM,
          fontWeight: FontWeight.w400,
          color: AppColors.lightForeground,
        ),
        bodySmall: TextStyle(
          fontSize: AppSizes.fontS,
          fontWeight: FontWeight.w400,
          color: AppColors.lightMutedForeground,
        ),
        labelLarge: TextStyle(
          fontSize: AppSizes.fontM,
          fontWeight: FontWeight.w500,
          color: AppColors.lightForeground,
        ),
        labelMedium: TextStyle(
          fontSize: AppSizes.fontS,
          fontWeight: FontWeight.w500,
          color: AppColors.lightForeground,
        ),
        labelSmall: TextStyle(
          fontSize: AppSizes.fontXS,
          fontWeight: FontWeight.w500,
          color: AppColors.lightMutedForeground,
          letterSpacing: 0.5,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.lightForeground,
        size: AppSizes.iconL,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
      ),
    );
  }
}
