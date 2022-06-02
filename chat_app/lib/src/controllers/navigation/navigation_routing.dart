part of 'navigation_service.dart';

PageRoute getRoute(RouteSettings settings) {
  switch (settings.name) {
    case Wrapper.route:
      print("1Hellooooooooooooooooooooooooooooooooooo");

      return FadeRoute(page: Wrapper(), settings: settings);
    case LoginScreen.route:
      print("2Hellooooooooooooooooooooooooooooooooooo");
      return FadeRoute(page: const LoginScreen(), settings: settings);
    case HomeScreen.route:
      print("3Hellooooooooooooooooooooooooooooooooooo");

      return FadeRoute(page: const HomeScreen(), settings: settings);
    default:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}
