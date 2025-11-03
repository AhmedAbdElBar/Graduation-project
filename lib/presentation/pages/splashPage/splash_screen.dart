// import 'package:flutter/material.dart';
// import 'auth_screen.dart';
//
// import '../../core/resources/color_value_manager.dart';
// import '../../core/resources/fonts_value_manager.dart';
//
// class SplashScreen extends StatefulWidget {
//   static const String routeName = "Splash screen";
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future future = Future.delayed(const Duration(seconds: 2), () {
//       Navigator.pushReplacementNamed(context, AuthScreen.routeName);
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: ColorValueManager.vPrimaryColor,
//       body: Center(
//         child: Text(
//           "My Job",
//           style: TextStyle(
//             color: ColorValueManager.vWhiteColor,
//             fontFamily: "BBH",
//             fontWeight: FontWeightManager.vFW600,
//             fontSize: FontSizeValueManager.vFS35,
//           ),
//         ),
//       ),
//     );
//   }
// }
