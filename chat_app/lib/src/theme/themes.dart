import 'package:flutter/material.dart';

class Themes {
  Color primaryLight = const Color(0xff6C63FF);
  Color primaryDark = const Color(0xffD3D0FF);
  Color tertiaryDark = const Color(0xff363636);
  Color tertiaryLight = const Color(0xffEEEEEE);

  ThemeData light() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color:
                primaryLight), // set backbutton color here which will reflect in all screens.
      ),
      colorScheme: const ColorScheme.light().copyWith(
        primary: primaryLight,
        secondary: Colors.black26,
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
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: const TextStyle(
          fontSize: 16,
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
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
            color:
                primaryDark), // set backbutton color here which will reflect in all screens.
      ),
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
          // fontSize: 16,

          fontWeight: FontWeight.bold,
        ),
        headlineMedium: const TextStyle(
          fontSize: 16,
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
