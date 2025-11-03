import 'package:flutter/material.dart';
import 'package:login_page/presentation/core/resources/border_radius_manager.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';
import 'package:login_page/presentation/core/resources/padding_margin_value_manager.dart';
import 'package:login_page/presentation/core/resources/size_value_manager.dart';
import '../../../../data/firebase_auth/log_in_user.dart';
import '../../../core/resources/strings_value_manager.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService(); // ✅ استخدم الكلاس الجديد

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocus.hasFocus;
      });
    });
    _passwordFocus.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('login'),
      children: [
        TextField(
          controller: _emailController,
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: _isEmailFocused
                ? StringsValueManager.vTextFiledHintEmailInFocus
                : StringsValueManager.vTextFiledHintEmail,
            labelStyle: const TextStyle(color: ColorValueManager.vBlack45Color),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorValueManager.vGrayColor,
                width: WidthValueManager.vW1_5,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorValueManager.vBlack45Color),
            ),
          ),
        ),
        const SizedBox(height: HeightValueManager.vH20),
        TextField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: _isPasswordFocused
                ? StringsValueManager.vTextFiledHintPasswordInFocus
                : StringsValueManager.vTextFiledHintPassword,
            labelStyle: const TextStyle(color: ColorValueManager.vBlack45Color),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorValueManager.vGrayColor,
                width: WidthValueManager.vW1_5,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
            ),
          ),
        ),
        const SizedBox(height: HeightValueManager.vH20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text(
                StringsValueManager.vLForgetPassword,
                style: TextStyle(color: ColorValueManager.vBlack45Color),
              ),
            ),
          ],
        ),
        const SizedBox(height: HeightValueManager.vH28),
        _isLoading
            ? Container(
                padding: PaddingValueManager.eAll15,
                width: WidthValueManager.vW150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorValueManager.vGrayColor,
                  borderRadius: RadiusValueManager.vBR100,
                ),
                child: const SizedBox(
                  width: WidthValueManager.vW20,
                  height: HeightValueManager.vH20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: ColorValueManager.vWhiteColor,
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
                    color: ColorValueManager.vGrayColor,
                    borderRadius: RadiusValueManager.vBR100,
                  ),
                  child: const Text(
                    StringsValueManager.vLoginButton,
                    style: TextStyle(
                      color: ColorValueManager.vWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
