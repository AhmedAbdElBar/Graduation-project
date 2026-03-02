import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';
import 'package:login_page/presentation/core/resources/size_value_manager.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final TextEditingController emailController = TextEditingController();
  bool loading = false;

  Future<void> sendResetEmail() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      if (!mounted) return; 

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("We sent a reset link to your email"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Try again")),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("reset password"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Please enter your email",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: HeightValueManager.vH20),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: " email",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("cancel"),
        ),
        ElevatedButton(
          onPressed: loading ? null : sendResetEmail,
          child: loading
              ? const SizedBox(
                  height: HeightValueManager.vH20,
                  width: WidthValueManager.vW20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: ColorValueManager.vWhiteColor),
                )
              : const Text("send"),
        ),
      ],
    );
  }
}
