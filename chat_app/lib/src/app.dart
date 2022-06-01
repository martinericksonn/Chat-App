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
      theme: ThemeData(
        // ignore: prefer_const_constructors
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light, // 2
        ),
      ),
      darkTheme: ThemeData.dark(),
      builder: (context, Widget? child) => child as Widget,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      initialRoute: LoginScreen.route,
    );
  }
}
