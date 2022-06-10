import 'package:chat_app/src/service_locators.dart';
import 'package:chat_app/src/settings/settings_controller.dart';
import 'package:chat_app/src/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController
      .loadSettings()
      .then((value) => {setupLocators(settingsController)});

  runApp(MyApp(
    settingsController: settingsController,
  ));
}
