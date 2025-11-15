import 'package:flutter/material.dart';
import 'package:login_page/presentation/core/resources/border_radius_manager.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';
import 'package:login_page/presentation/core/resources/padding_margin_value_manager.dart';
import 'package:login_page/presentation/core/resources/size_value_manager.dart';
import 'package:login_page/presentation/core/resources/strings_value_manager.dart';
import 'package:login_page/presentation/pages/auth/widgets/custom_text_field.dart';
import 'package:login_page/presentation/pages/home/screen/home_screen.dart';
import '../../../../data/firebase_auth/log_in_user.dart';
import 'custom_dialog_for_reset_password.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage("Please fill in all fields", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final message = await _authService.loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (message == null) {
      _showMessage("Login successful!");
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      _showMessage(message, isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: isError ? Colors.redAccent : Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('login'),
      children: [
        /// Email Field
        CustomTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          label: StringsValueManager.vTextFiledHintEmail,
          labelInFocus: StringsValueManager.vTextFiledHintEmailInFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: HeightValueManager.vH20),

        /// Password Field
        CustomTextField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          label: StringsValueManager.vTextFiledHintPassword,
          labelInFocus: StringsValueManager.vTextFiledHintPasswordInFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          isPassword: true,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          onObscureToggle: (newValue) {
            setState(() {
              _obscurePassword = newValue;
            });
          },
        ),
        const SizedBox(height: HeightValueManager.vH20),

        /// Forget Password
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const ResetPasswordDialog(),
                );
              },
              child: const Text(
                StringsValueManager.vLForgetPassword,
                style: TextStyle(color: ColorValueManager.vWhiteColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: HeightValueManager.vH28),

        /// Login Button
        _isLoading
            ? Container(
                padding: PaddingValueManager.eAll15,
                width: WidthValueManager.vW150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorValueManager.vWhiteColor,
                  borderRadius: RadiusValueManager.vBR100,
                ),
                child: const SizedBox(
                  width: WidthValueManager.vW20,
                  height: HeightValueManager.vH20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: ColorValueManager.vBlackColor,
                  ),
                ),
              )
            : GestureDetector(
                onTap: _login,
                child: Container(
                  padding: PaddingValueManager.eAll15,
                  width: WidthValueManager.vW150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorValueManager.vWhiteColor,
                    borderRadius: RadiusValueManager.vBR100,
                  ),
                  child: const Text(
                    StringsValueManager.vLoginButton,
                    style: TextStyle(
                      color: ColorValueManager.vBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
