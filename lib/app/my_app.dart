import 'package:flutter/material.dart';
import '../presentation/core/resources/route_manager.dart';
import '../presentation/pages/authPage/screens/auth_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: RouteManager.routes,
      initialRoute: AuthScreen.routeName,
    );
  }
}
