import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/presentation/pages/authPage/screens/auth_screen.dart';
import 'package:login_page/presentation/pages/home/screen/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  static const String routeName = '/authWrapper';
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // بنستخدم StreamBuilder عشان يسمع دايمًا لحالة تسجيل الدخول
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // لسه بيشوف المستخدم (شاشة تحميل بسيطة)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // المستخدم مسجل دخول ✅
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // المستخدم مش مسجل ❌
        return const AuthScreen();
      },
    );
  }
}
