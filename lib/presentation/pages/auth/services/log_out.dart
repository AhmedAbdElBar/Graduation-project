import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/presentation/pages/auth/screens/auth_screen.dart';

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  if(!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const AuthScreen()),
    (route) => false,
  );
}
