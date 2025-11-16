import 'package:flutter/material.dart';
import 'package:login_page/presentation/pages/splashPage/splash_screen.dart';
import '../presentation/core/resources/route_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: RouteManager.routes,
      initialRoute: SplashScreen.routeName,
    );
  }
}
