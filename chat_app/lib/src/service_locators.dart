import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/controllers/navigation/navigation_service.dart';
import 'package:chat_app/src/settings/settings_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocators(SettingsController settingsController) {
  locator.registerSingleton<NavigationService>(
      NavigationService(settingsController: settingsController));
  locator.registerSingleton<AuthController>(AuthController());
}
