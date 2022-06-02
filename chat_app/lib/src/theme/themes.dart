import 'package:flutter/material.dart';

class Themes {
  Color primaryLight = const Color(0xff6C63FF);
  Color primaryDark = const Color(0xffD3D0FF);
  Color tertiaryDark = const Color(0xff363636);
  Color tertiaryLight = const Color(0xffEEEEEE);

  ThemeData light() {
    return ThemeData(
      colorScheme: const ColorScheme.light().copyWith(
        primary: primaryLight,
        secondary: Colors.black54,
        tertiary: tertiaryLight,
      ),
      dividerTheme: const DividerThemeData(
        space: 20,
        thickness: 1,
        indent: 20,
        endIndent: 20,
      ),
      textTheme: TextTheme(
        titleMedium: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: primaryLight,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ThemeData dark() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(
        primary: primaryDark,
        secondary: Colors.white54,
        onBackground: Colors.white,
        tertiary: tertiaryDark,
      ),
      dividerTheme: DividerThemeData(
        color: tertiaryDark,
        space: 20,
        thickness: 1,
        indent: 20,
        endIndent: 20,
      ),
      textTheme: TextTheme(
        titleMedium: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryDark,
        ),
      ),
    );
  }
}
