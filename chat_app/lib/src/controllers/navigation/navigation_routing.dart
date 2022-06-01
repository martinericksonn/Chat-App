part of 'navigation_service.dart';

PageRoute getRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.route:
      return FadeRoute(page: const LoginScreen(), settings: settings);
    case HomeScreen.route:
      return FadeRoute(page: const HomeScreen(), settings: settings);
    default:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}
