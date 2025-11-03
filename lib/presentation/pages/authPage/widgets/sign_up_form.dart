import 'package:flutter/material.dart';
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

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isConfirmFocused = false;

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

    _confirmFocus.addListener(() {
      setState(() {
        _isConfirmFocused = _confirmFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('SignUp'),
      children: [
        // Email
        TextField(
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
        GestureDetector(
          onTap: () {},
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
