import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/splash_view.dart';
import 'views/main_page.dart';

class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  // Add other routes here as needed
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for \${settings.name}'),
            ),
          ),
        );
    }
  }
}
