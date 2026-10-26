import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF6F4E37);
  static const Color secondary = Color(0xFFA67C52);
  static const Color surface = Color(0xFFF5EDE3);
  static const Color onSurface = Color(0xFF2D1B12);
  static const Color scaffoldBackgroundColor = Color(0xFFF8F4EF);

  static const color2 = Color(0xFF3E2723);
  static const color3 = Color(0xFF4E342E);
  static const color4 = Color(0xFF5D4037);

  static const indicator = Color(0xFFE8D8C3);
  static const border = Color(0xFFD7C2AE);

  static ThemeData coffeeTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: primary),

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primary, // Café principal
      onPrimary: Colors.white,
      secondary: secondary, // Café claro
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: surface, // Crema suave
      onSurface: onSurface,
    ),

    scaffoldBackgroundColor: scaffoldBackgroundColor,

    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(color: primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primary, width: 2),
      ),
    ),

    textTheme: const TextTheme(
      headlineMedium: TextStyle(color: onSurface, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: color2, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: color3),
      bodyMedium: TextStyle(color: color4),
    ),

    dividerColor: const Color(0xFFE2D6C7),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: indicator,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(color: primary, fontWeight: FontWeight.w500),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primary,
      unselectedItemColor: indicator,
    ),
  );
}
