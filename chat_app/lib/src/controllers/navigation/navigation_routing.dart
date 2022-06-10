part of 'navigation_service.dart';

material.PageRoute getRoute(RouteSettings settings) {
  NavigationService nav = locator<NavigationService>();
  switch (settings.name) {
    // case Wrapper.route:
    //   return FadeRoute(page: Wrapper(), settings: settings);
    case LoginScreen.route:
      return FadeRoute(page: const LoginScreen(), settings: settings);
    case HomeScreen.route:
      return FadeRoute(
          page: HomeScreen(settingsController: nav.settingsController),
          settings: settings);
    default:
      return MaterialPageRoute(
          builder: (context) =>
              HomeScreen(settingsController: nav.settingsController));
  }
}
