import 'package:flutter/material.dart';

/// Unified theme configuration using Material Design color palette.
///
/// This theme implements a professional color palette based on #777da7:
/// - Primary: Soft blue-purple (#777da7) for main actions and accents
/// - Dark Primary: Darker analogous (#7a49a5) for emphasized elements
/// - Light Primary: Light monochromatic (#a4a7be) for subtle backgrounds
/// - Accent: Triadic color (#7DA777) for secondary actions
/// - Tertiary: Complementary triadic (#A7777D) for additional accents
/// - Background: Slightly dark grey (#F5F5F5) for better contrast
/// - Surface: Pure white (#FFFFFF) for cards and elevated surfaces
/// - Text: Dark grey (#212121) for primary text, medium grey (#757575) for secondary
/// - Divider: Light grey (#BDBDBD) for separators

class AppTheme {
  // Primary color palette - main brand colors based on #777da7
  // PRIMARY COLOR: Soft blue-purple (#777da7) - used for main actions, buttons, and accents
  // RGB: 119, 125, 167 (28.95%, 30.41%, 40.63%)
  static const Color primaryColor = Color(0xFF777DA7);

  // DARK PRIMARY COLOR: Darker analogous purple (#7a49a5) - used for emphasized elements and hover states
  // This is one of the analogous colors, providing depth and contrast
  static const Color darkPrimaryColor = Color(0xFF7A49A5);

  // LIGHT PRIMARY COLOR: Light monochromatic (#a4a7be) - used for subtle backgrounds and containers
  // This is a lighter shade from the monochromatic palette for soft backgrounds
  static const Color lightPrimaryColor = Color(0xFFA4A7BE);

  // ACCENT COLOR: Triadic green (#7DA777) - used for secondary actions and highlights
  // This is one of the triadic colors, providing vibrant contrast for secondary elements
  static const Color accentColor = Color(0xFF7DA777);

  // TERTIARY COLOR: Triadic rose (#A7777D) - used for additional accents and highlights
  // This is the other triadic color, providing another accent option
  static const Color tertiaryColor = Color(0xFFA7777D);

  // Additional monochromatic colors from the palette (available for future use)
  // These are lighter and darker shades of the primary color for gradients and variations
  static const Color monochromaticDark = Color(0xFF777B9F); // Darker shade
  static const Color monochromaticLight1 = Color(0xFF8084A5); // Light shade 1
  static const Color monochromaticLight2 = Color(0xFF898DAB); // Light shade 2
  static const Color monochromaticLight3 = Color(0xFF9295B2); // Light shade 3
  static const Color monochromaticLight4 = Color(0xFF9B9EB8); // Light shade 4
  static const Color monochromaticLight5 = Color(0xFFADAFC5); // Lightest shade

  // Analogous colors - colors adjacent to the primary on the color wheel
  // These provide harmonious color options that work well together
  static const Color analogousPurple = Color(
    0xFF7A49A5,
  ); // Purple analogous (same as darkPrimaryColor)
  static const Color analogousBlue = Color(0xFF4974A5); // Blue analogous

  // Complementary color - neutral grey (#777777) for subtle backgrounds or borders
  // This provides a neutral option that complements the primary color
  static const Color complementaryGrey = Color(0xFF777777);

  // Text and icon colors
  // TEXT / ICONS: White for icons on colored backgrounds
  static const Color textIcons = Color(0xFFFFFFFF);

  // PRIMARY TEXT: Very dark grey (almost black) for main text content
  static const Color primaryText = Color(0xFF212121);

  // SECONDARY TEXT: Medium grey for secondary information
  static const Color secondaryText = Color(0xFF757575);

  // Background colors - slightly darker for better contrast
  // Background: Slightly dark grey for better contrast with white cards
  static const Color backgroundDark = Color(0xFFF5F5F5);

  // Surface: Pure white for cards and elevated surfaces (stands out from background)
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Surface variant: Light grey for input fields and subtle containers
  static const Color surfaceVariantLight = Color(0xFFFAFAFA);

  // Border and divider colors
  // DIVIDER COLOR: Light grey for dividers and borders
  static const Color dividerColor = Color(0xFFBDBDBD);

  // Border color: Slightly darker than divider for card borders
  static const Color borderColor = Color(0xFFE0E0E0);

  // Error color - modern red for warnings and errors
  static const Color errorRed = Color(0xFFFF5757);

  /// Creates the light theme for the application.
  ///
  /// This theme uses Material 3 design principles with the new color palette
  /// featuring blue-purple primary colors (#777da7), triadic accents, and darker background
  /// for improved contrast and visual hierarchy.
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.light(
      // Primary color - soft blue-purple (#777da7) for main actions, buttons, and accents
      primary: primaryColor,
      onPrimary: textIcons, // White text/icons on primary color
      // Primary container - light primary color for subtle backgrounds
      primaryContainer: lightPrimaryColor,
      onPrimaryContainer:
          darkPrimaryColor, // Dark primary for text on light primary
      // Secondary color - triadic green for secondary actions
      secondary: accentColor,
      onSecondary: textIcons, // White text/icons on accent color
      // Tertiary color - triadic rose for additional accents
      tertiary: tertiaryColor,
      onTertiary: textIcons, // White text/icons on tertiary color
      // Error color - for error states and destructive actions
      error: errorRed,
      onError: Colors.white,

      // Surface colors - white for cards and elevated surfaces (stands out from background)
      surface: surfaceWhite,
      onSurface: primaryText, // Dark grey text on white surface
      surfaceVariant:
          surfaceVariantLight, // Light grey for inputs and subtle containers
      onSurfaceVariant: secondaryText, // Medium grey text on variant surface
      // Background - slightly dark grey for better contrast with white cards
      background: backgroundDark,
      onBackground: primaryText, // Dark grey text on dark background
      // Outline - for borders and dividers
      outline: borderColor, // Slightly darker border for cards
      outlineVariant: dividerColor, // Light grey divider color
      // Brightness for the color scheme (light theme)
      brightness: Brightness.light,
    );

    return ThemeData(
      // Use Material 3 design system for modern Flutter styling
      useMaterial3: true,

      // Apply our custom color scheme
      colorScheme: colorScheme,

      // Scaffold background uses darker grey for better contrast with white cards
      scaffoldBackgroundColor: backgroundDark,

      // AppBar theme - clean and minimal with light primary color background
      appBarTheme: AppBarTheme(
        elevation: 0, // No shadow for flat, modern look
        scrolledUnderElevation: 1, // Subtle shadow when scrolling
        backgroundColor:
            lightPrimaryColor, // Light blue-purple background for AppBar
        foregroundColor:
            darkPrimaryColor, // Dark purple text/icons for contrast
        iconTheme: const IconThemeData(color: darkPrimaryColor),
        titleTextStyle: TextStyle(
          color: darkPrimaryColor, // Dark purple text
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5, // Tighter letter spacing for modern feel
        ),
        centerTitle: false,
      ),

      // Card theme - modern elevated cards with white background (contrasts with darker background)
      cardTheme: CardThemeData(
        elevation: 0, // Flat cards with borders instead of shadows
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
          side: BorderSide(color: borderColor.withOpacity(0.5), width: 1),
        ),
        color: surfaceWhite, // White cards stand out from darker background
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Button themes - modern, rounded buttons with new color palette
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0, // Flat buttons
          backgroundColor: primaryColor, // Soft blue-purple for primary actions
          foregroundColor: textIcons, // White text/icons
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
          foregroundColor: primaryColor, // Blue-purple text and border
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: primaryColor, width: 1.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor, // Blue-purple text
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Input decoration theme - clean, modern input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariantLight, // Light grey background for inputs
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ), // Blue-purple focus border
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

      // Bottom navigation bar theme - clean bottom bar with surface variant background
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            surfaceVariantLight, // Light grey background for nav bar
        selectedItemColor: primaryColor, // Blue-purple for selected item
        unselectedItemColor: secondaryText, // Medium grey for unselected items
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

      // Typography - modern, clean text styles with new color palette
      textTheme: TextTheme(
        // Headline styles for main titles
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryText, // Dark grey for primary text
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryText,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryText,
          letterSpacing: -0.5,
        ),

        // Title styles for section headers
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primaryText,
          letterSpacing: -0.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryText,
          letterSpacing: -0.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryText,
          letterSpacing: -0.2,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryText,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryText,
          letterSpacing: 0,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryText,
          letterSpacing: 0.1,
        ),

        // Body styles for regular text
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: primaryText,
          height: 1.5, // Line height for readability
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryText,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: secondaryText, // Medium grey for secondary text
          height: 1.4,
        ),

        // Label styles for buttons and small text
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryText,
          letterSpacing: 0.5,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: primaryText,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: secondaryText, // Medium grey for small labels
          letterSpacing: 0.5,
        ),
      ),

      // Divider theme - subtle dividers using divider color from palette
      dividerTheme: DividerThemeData(
        color: dividerColor.withOpacity(0.5), // Light grey divider
        thickness: 1,
        space: 1,
      ),

      // Icon theme - consistent icon styling
      iconTheme: const IconThemeData(
        color: secondaryText,
        size: 24,
      ), // Medium grey icons
      // ListTile theme - clean list items
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
