import 'package:flutter/material.dart';
import 'package:login_page/presentation/pages/authPage/widgets/auth_wrapper.dart';
import '../presentation/core/resources/route_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: RouteManager.routes,
      initialRoute: AuthWrapper.routeName,
    );
  }
}
