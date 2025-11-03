import 'package:flutter/material.dart';
import 'package:login_page/data/firebase_auth/register_user.dart';
import '../../../core/resources/border_radius_manager.dart';
import '../../../core/resources/color_value_manager.dart';
import '../../../core/resources/padding_margin_value_manager.dart';
import '../../../core/resources/size_value_manager.dart';
import '../../../core/resources/strings_value_manager.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final AuthServiceForRegister _authService =
      AuthServiceForRegister(); // ✅ استخدمنا الكلاس المنفصل

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isConfirmFocused = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(() {
      setState(() => _isEmailFocused = _emailFocus.hasFocus);
    });
    _passwordFocus.addListener(() {
      setState(() => _isPasswordFocused = _passwordFocus.hasFocus);
    });
    _confirmFocus.addListener(() {
      setState(() => _isConfirmFocused = _confirmFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showMessage("Please fill in all fields", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final message = await _authService.registerUser(
      email: email,
      password: password,
      confirmPassword: confirm,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (message == null) {
      _showMessage("Account created successfully!");
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
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
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
      key: const ValueKey('SignUp'),
      children: [
        // Email
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

        // Password
        TextField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          obscureText: true,
          textInputAction: TextInputAction.next,
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
              borderSide: BorderSide(color: ColorValueManager.vBlack45Color),
            ),
          ),
        ),
        const SizedBox(height: HeightValueManager.vH20),

        // Confirm Password
        TextField(
          controller: _confirmController,
          focusNode: _confirmFocus,
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: _isConfirmFocused
                ? StringsValueManager.vTextFiledHintCPasswordInFocus
                : StringsValueManager.vTextFiledHintCPassword,
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
        const SizedBox(height: HeightValueManager.vH28),

        // Sign Up Button
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
                onTap: _signUp,
                child: Container(
                  padding: PaddingValueManager.eAll15,
                  width: WidthValueManager.vW150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorValueManager.vGrayColor,
                    borderRadius: RadiusValueManager.vBR100,
                  ),
                  child: const Text(
                    StringsValueManager.vSignUpButton,
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
