import 'package:flutter/material.dart';
import 'package:menu/res/routes/routes_name.dart';
import 'package:menu/view/menu_view/menu_screen.dart';
import 'package:menu/view/sign_in_view/sign_in_screen.dart';
import 'package:menu/view/splash_view/splash_screen.dart';

/// This class manages app-wide route generation for navigation.
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RoutesName.signInScreen:
        return MaterialPageRoute(builder: (context) => const SignInScreen());
      case RoutesName.menuScreenOne:
        return MaterialPageRoute(builder: (context) => const MenuScreen());
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );
    }
  }
}
