import 'package:flutter/cupertino.dart';
import '../../pages/authPage/screens/auth_screen.dart';
// import '../../screens/page/splash_screen.dart';

class RouteManager {
  static Map<String, WidgetBuilder> routes = {
    AuthScreen.routeName: (context) => const AuthScreen(),
    // SplashScreen.routeName: (context) => const SplashScreen(),
  };
}
