import 'package:flutter/material.dart';
import 'package:login_page/data/firebase_auth/register_user.dart';
import '../../../core/resources/border_radius_manager.dart';
import '../../../core/resources/color_value_manager.dart';
import '../../../core/resources/padding_margin_value_manager.dart';
import '../../../core/resources/size_value_manager.dart';
import '../../../core/resources/strings_value_manager.dart';
import '../../home/screen/home_screen.dart';
import 'custom_text_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final AuthServiceForRegister _authService = AuthServiceForRegister();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

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
        CustomTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          label: StringsValueManager.vTextFiledHintEmail,
          labelInFocus: StringsValueManager.vTextFiledHintEmailInFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: HeightValueManager.vH20),
        CustomTextField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          label: StringsValueManager.vTextFiledHintPassword,
          labelInFocus: StringsValueManager.vTextFiledHintPasswordInFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          isPassword: true,
          obscureText: _obscurePassword,
          onObscureToggle: (v) => setState(() => _obscurePassword = v),
        ),
        const SizedBox(height: HeightValueManager.vH20),
        CustomTextField(
          controller: _confirmController,
          focusNode: _confirmFocus,
          label: StringsValueManager.vTextFiledHintCPassword,
          labelInFocus: StringsValueManager.vTextFiledHintCPasswordInFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          isPassword: true,
          obscureText: _obscureConfirm,
          onObscureToggle: (v) => setState(() => _obscureConfirm = v),
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
