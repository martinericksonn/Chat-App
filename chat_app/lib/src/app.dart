import 'package:chat_app/src/screens/authentication/login_screen.dart';
import 'package:chat_app/src/service_locators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controllers/navigation/navigation_service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Theme.of(context).primaryColorDark,
    //   ),
    // );
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_constructors
      // appBarTheme: AppBarTheme(
      //   // systemOverlayStyle: SystemUiOverlayStyle.light, // 2
      // ),
      //     colorScheme: ColorScheme(
      //   primary: Colors.red,
      //   onPrimary: Colors.red,
      //   secondary: Colors.red,
      //   onSecondary: Colors.red,
      //   error: Colors.red,
      //   onError: Colors.red,
      //   background: Colors.red,
      //   onBackground: Colors.red,
      //   surface: Colors.red,
      //   onSurface: Colors.red,
      //   brightness: Brightness.light,
      // )
      theme: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
        primary: const Color(0xff6C63FF),
        secondary: Colors.black54,
      )),
      darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xffD3D0FF),
            secondary: Colors.white54,
            onBackground: Colors.white,
          )),
      builder: (context, Widget? child) => child as Widget,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      initialRoute: LoginScreen.route,
    );
  }
}
