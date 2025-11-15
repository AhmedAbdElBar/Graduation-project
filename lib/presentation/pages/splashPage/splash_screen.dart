import 'package:flutter/material.dart';
import 'package:login_page/presentation/pages/auth/widgets/auth_wrapper.dart';

import '../../core/resources/color_value_manager.dart';
import '../../core/resources/fonts_value_manager.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "Splash screen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future future = Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AuthWrapper.routeName);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/Animation 3.png",
              fit: BoxFit.cover,
            ),
          ),
          const Center(
            child: Text(
              "Logo",
              style: TextStyle(
                color: ColorValueManager.vWhiteColor,
                fontFamily: "BBH",
                fontWeight: FontWeightManager.vFW600,
                fontSize: FontSizeValueManager.vFS35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
