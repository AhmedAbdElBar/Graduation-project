import 'package:flutter/cupertino.dart';
import 'package:login_page/presentation/pages/home/screen/home_screen.dart';
import '../../pages/authPage/screens/auth_screen.dart';
// import '../../screens/page/splash_screen.dart';

class RouteManager {
  static Map<String, WidgetBuilder> routes = {
    AuthScreen.routeName: (context) => const AuthScreen(),
    HomeScreen.routeName: (context) => const HomeScreen(),
    // SplashScreen.routeName: (context) => const SplashScreen(),
  };
}
