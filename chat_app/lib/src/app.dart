import 'package:chat_app/src/service_locators.dart';
import 'package:chat_app/src/theme/themes.dart';
import 'package:chat_app/wrapper.dart';
import 'package:flutter/material.dart';

import 'controllers/navigation/navigation_service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  final Themes themes = Themes();
  MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      theme: themes.light(),
      darkTheme: themes.dark(),
      builder: (context, Widget? child) => child as Widget,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      initialRoute: Wrapper.route,
    );
  }
}
