import 'package:flutter/material.dart';

/// Unified theme configuration inspired by Stripe, Venmo, and Spotify.
///
/// This theme combines:
/// - Stripe's clean, professional aesthetic with lots of white space
/// - Venmo's vibrant, friendly blue-green palette
/// - Spotify's modern card-based design with subtle shadows
///
/// The color scheme uses:
/// - Primary: Vibrant blue (#635BFF - Stripe-inspired, professional)
/// - Secondary: Modern green (#00D4AA - Venmo-inspired, friendly)
/// - Surface: Clean whites with subtle grays for depth
/// - Background: Pure white for that clean, professional feel

class AppTheme {
  // Primary brand color - vibrant blue inspired by Stripe/Venmo
  // This is the main accent color used throughout the app
  static const Color primaryBlue = Color(0xFF635BFF);

  // Secondary accent color - modern teal/green inspired by Venmo
  // Used for success states and secondary actions
  static const Color accentTeal = Color(0xFF00D4AA);

  // Error color - modern red for warnings and errors
  static const Color errorRed = Color(0xFFFF5757);

  // Background colors - clean whites and subtle grays
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF8F9FA);
  static const Color surfaceGray = Color(0xFFF5F7FA);

  // Text colors - proper contrast for accessibility
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Border and divider colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color dividerLight = Color(0xFFE5E7EB);

  /// Creates the light theme for the application.
  ///
  /// This theme uses Material 3 design principles with a custom color scheme
  /// that gives a professional, modern feel similar to Stripe/Venmo/Spotify.
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.light(
      // Primary color - used for main actions, buttons, and accents
      primary: primaryBlue,
      onPrimary: Colors.white,

      // Primary container - lighter shade for backgrounds with primary color
      primaryContainer: primaryBlue.withOpacity(0.1),
      onPrimaryContainer: primaryBlue,

      // Secondary color - used for secondary actions
      secondary: accentTeal,
      onSecondary: Colors.white,

      // Tertiary color - used for additional accents
      tertiary: const Color(0xFF9333EA), // Purple accent
      onTertiary: Colors.white,

      // Error color - for error states and destructive actions
      error: errorRed,
      onError: Colors.white,

      // Surface colors - for cards and elevated surfaces
      surface: backgroundWhite,
      onSurface: textPrimary,
      surfaceVariant: surfaceGray,
      onSurfaceVariant: textSecondary,

      // Background - main app background
      background: backgroundWhite,
      onBackground: textPrimary,

      // Outline - for borders and dividers
      outline: borderLight,
      outlineVariant: dividerLight,

      // Brightness for the color scheme (light theme)
      brightness: Brightness.light,
    );

    return ThemeData(
      // Use Material 3 design system for modern Flutter styling
      useMaterial3: true,

      // Apply our custom color scheme
      colorScheme: colorScheme,

      // Scaffold background uses our custom background color
      scaffoldBackgroundColor: backgroundWhite,

      // AppBar theme - clean and minimal like Stripe
      appBarTheme: AppBarTheme(
        elevation: 0, // No shadow for flat, modern look
        scrolledUnderElevation: 1, // Subtle shadow when scrolling
        backgroundColor: backgroundWhite,
        foregroundColor: textPrimary,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5, // Tighter letter spacing for modern feel
        ),
        centerTitle: false,
      ),

      // Card theme - modern elevated cards with subtle shadows
      cardTheme: CardThemeData(
        elevation: 0, // Flat cards with borders instead of shadows
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
          side: BorderSide(color: borderLight.withOpacity(0.5), width: 1),
        ),
        color: backgroundWhite,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Button themes - modern, rounded buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0, // Flat buttons
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: primaryBlue, width: 1.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Input decoration theme - clean, modern input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorRed, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Bottom navigation bar theme - clean bottom bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: backgroundWhite,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textTertiary,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8, // Subtle elevation for depth
      ),

      // Typography - modern, clean text styles
      textTheme: TextTheme(
        // Headline styles for main titles
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),

        // Title styles for section headers
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.1,
        ),

        // Body styles for regular text
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5, // Line height for readability
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.4,
        ),

        // Label styles for buttons and small text
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textSecondary,
          letterSpacing: 0.5,
        ),
      ),

      // Divider theme - subtle dividers
      dividerTheme: DividerThemeData(
        color: dividerLight.withOpacity(0.5),
        thickness: 1,
        space: 1,
      ),

      // Icon theme - consistent icon styling
      iconTheme: const IconThemeData(color: textSecondary, size: 24),

      // ListTile theme - clean list items
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
