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
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Color(0xff6C63FF)),
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
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryDark,
        ),
      ),
    );
  }
}
