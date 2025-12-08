import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Sidebar Colors
  static const Color sidebarColor = Color(0xFF1E293B);
  static const Color sidebarHoverColor = Color(0xFF334155);
  static const Color sidebarActiveColor = Color(0xFF3B82F6);

  // Font Families
  static const String persianFont = 'BNazanin';
  static const String englishFont = 'Ubuntu';

  // Unified Font Configuration - تنظیمات یکپارچه فونت
  static const double fontSizeDisplayLarge = 36.0;  // بود: 32
  static const double fontSizeDisplayMedium = 32.0; // بود: 28
  static const double fontSizeDisplaySmall = 28.0;  // بود: 24
  static const double fontSizeHeadlineLarge = 24.0; // بود: 20
  static const double fontSizeHeadlineMedium = 22.0; // بود: 20
  static const double fontSizeHeadlineSmall = 20.0; // بود: 18
  static const double fontSizeTitleLarge = 18.0;    // بود: 16
  static const double fontSizeTitleMedium = 17.0;   // بود: 14
  static const double fontSizeTitleSmall = 16.0;    // بود: 14
  static const double fontSizeBodyLarge = 17.0;     // بود: 14
  static const double fontSizeBodyMedium = 16.0;   // بود: 12
  static const double fontSizeBodySmall = 14.0;     // بود: 11
  static const double fontSizeLabelLarge = 16.0;
  static const double fontSizeLabelMedium = 15.0;
  static const double fontSizeLabelSmall = 14.0;
  
  // Font Weights - وزن فونت‌ها (پررنگ‌تر)
  static const FontWeight fontWeightNormal = FontWeight.w600;    // بود: normal/w400
  static const FontWeight fontWeightMedium = FontWeight.w600;   // بود: w500
  static const FontWeight fontWeightBold = FontWeight.bold;    // بود: w600

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    fontFamily: persianFont, // فونت پیش‌فرض فارسی
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeHeadlineLarge,
        fontWeight: fontWeightBold,
        color: textPrimaryColor,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontFamily: persianFont,
          fontSize: fontSizeBodyLarge,
          fontWeight: fontWeightMedium,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: primaryColor),
        textStyle: const TextStyle(
          fontFamily: persianFont,
          fontSize: fontSizeBodyLarge,
          fontWeight: fontWeightMedium,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontFamily: persianFont,
          fontSize: fontSizeBodyLarge,
          fontWeight: fontWeightMedium,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeBodyLarge,
        fontWeight: fontWeightNormal,
        color: textSecondaryColor,
      ),
      hintStyle: const TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeBodyLarge,
        fontWeight: fontWeightNormal,
        color: textSecondaryColor,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeDisplayLarge,
        fontWeight: fontWeightBold,
        color: textPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeDisplayMedium,
        fontWeight: fontWeightBold,
        color: textPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeDisplaySmall,
        fontWeight: fontWeightBold,
        color: textPrimaryColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeHeadlineLarge,
        fontWeight: fontWeightBold,
        color: textPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeHeadlineMedium,
        fontWeight: fontWeightBold,
        color: textPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeHeadlineSmall,
        fontWeight: fontWeightBold,
        color: textPrimaryColor,
      ),
      titleLarge: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeTitleLarge,
        fontWeight: fontWeightBold,
        color: textPrimaryColor,
      ),
      titleMedium: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeTitleMedium,
        fontWeight: fontWeightMedium,
        color: textPrimaryColor,
      ),
      titleSmall: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeTitleSmall,
        fontWeight: fontWeightMedium,
        color: textPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeBodyLarge,
        fontWeight: fontWeightNormal,
        color: textPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeBodyMedium,
        fontWeight: fontWeightNormal,
        color: textPrimaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeBodySmall,
        fontWeight: fontWeightNormal,
        color: textSecondaryColor,
      ),
      labelLarge: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeLabelLarge,
        fontWeight: fontWeightMedium,
        color: textPrimaryColor,
      ),
      labelMedium: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeLabelMedium,
        fontWeight: fontWeightNormal,
        color: textPrimaryColor,
      ),
      labelSmall: TextStyle(
        fontFamily: persianFont,
        fontSize: fontSizeLabelSmall,
        fontWeight: fontWeightNormal,
        color: textSecondaryColor,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
    ),
  );

  // Dark Theme (optional)
  static ThemeData darkTheme = ThemeData(
    fontFamily: persianFont, // فونت پیش‌فرض فارسی
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF1E1E1E),
      error: errorColor,
    ),
  );
}
