import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/screens/authentication/login_screen.dart';
import 'package:chat_app/src/screens/home/home_screen.dart';
import 'package:chat_app/src/service_locators.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);
  static const String route = 'wrapper-screen';
  final AuthController _authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Navigator(
        restorationScopeId: 'app',

        ///Automatically sends the user to AuthScreen where it evaluates log in state
        initialRoute: LoginScreen.route,
        onGenerateRoute: (RouteSettings settings) {
          ///this is a default loader screen, can be refactored for future reuse;
          Widget child = const Scaffold(
            body: Center(
              child: SizedBox(
                  width: 50, height: 50, child: CircularProgressIndicator()),
            ),
          );
          if (_authController.currentUser != null) {
            print('hello world');
          }
          switch (settings.name) {
            case LoginScreen.route:
              print(settings.name);
              child = const LoginScreen();
              break;
            case HomeScreen.route:
              print('22');
              child = const HomeScreen();
          }
          return MaterialPageRoute(builder: (context) => child);
        });
  }
}
