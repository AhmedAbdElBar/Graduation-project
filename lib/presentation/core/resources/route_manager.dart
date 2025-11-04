import 'package:flutter/cupertino.dart';
import 'package:login_page/presentation/pages/home_bage.dart';
import '../../pages/authPage/screens/auth_screen.dart';
// import '../../screens/page/splash_screen.dart';

class RouteManager {
  static Map<String, WidgetBuilder> routes = {
    AuthScreen.routeName: (context) => const AuthScreen(),
    HomePage.routeName: (context) => const HomePage(),
    // SplashScreen.routeName: (context) => const SplashScreen(),
  };
}
