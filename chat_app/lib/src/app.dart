import 'package:chat_app/src/service_locators.dart';
import 'package:chat_app/wrapper.dart';
import 'package:flutter/material.dart';

import 'controllers/navigation/navigation_service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
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
      initialRoute: Wrapper.route,
    );
  }
}
