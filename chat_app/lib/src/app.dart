import 'package:chat_app/src/service_locators.dart';
import 'package:chat_app/src/settings/settings_controller.dart';
import 'package:chat_app/src/theme/themes.dart';
import 'package:chat_app/wrapper.dart';
import 'package:flutter/material.dart';

import 'controllers/navigation/navigation_service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  final SettingsController settingsController;
  final Themes themes = Themes();
  MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            restorationScopeId: 'app',
            debugShowCheckedModeBanner: false,
            theme: themes.light(),
            darkTheme: themes.dark(),
            themeMode: settingsController.themeMode,
            builder: (context, Widget? child) => child as Widget,
            navigatorKey: locator<NavigationService>().navigatorKey,
            onGenerateRoute: locator<NavigationService>().getRoute,
            // initialRoute: Wrapper.route,
          );
        });
  }
}
