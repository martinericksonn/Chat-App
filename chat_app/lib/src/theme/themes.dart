import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class Themes {
  // Color primaryDark = const Color(0xff6C63FF);
  // Color primaryLight = const Color(0xffD3D0FF);
  Color primaryLight = const Color(0xff6C63FF);
  Color primaryDark = const Color(0xffD3D0FF);
  Color tertiaryDark = const Color(0xff363636);
  Color tertiaryLight = const Color(0xffEEEEEE);
  // bool isDark = false;
  changeNavigationColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setNavigationBarColor(color, animate: true);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  ThemeData light() {
    // FlutterStatusbarcolor.setNavigationBarColor(Colors.white, animate: true);
    return ThemeData(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryLight),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        inversePrimary: primaryDark,
        primary: primaryLight,
        secondary: Colors.black38,
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

  changeStatusbarColor(context) async {
    print(Theme.of(context).scaffoldBackgroundColor);
    if (Theme.of(context).scaffoldBackgroundColor.computeLuminance() > 0.5) {
      FlutterStatusbarcolor.setNavigationBarColor(Colors.black, animate: true);
    } else {
      FlutterStatusbarcolor.setNavigationBarColor(Colors.white, animate: true);
    }
  }

  ThemeData dark() {
    return ThemeData.dark().copyWith(
      // ignore: prefer_const_constructor,
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   systemNavigationBarIconBrightness: Brightness.dark,
      //   statusBarIconBrightness: Brightness.dark,
      //   systemNavigationBarColor: Colors.black,
      //   statusBarColor: Colors.black,
      //   //color set to transperent or set your own color
      // ));
      appBarTheme: AppBarTheme(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
            color:
                primaryDark), // set backbutton color here which will reflect in all screens.
      ),
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(
        inversePrimary: primaryLight,
        primary: primaryDark,
        secondary: Colors.white70,
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
