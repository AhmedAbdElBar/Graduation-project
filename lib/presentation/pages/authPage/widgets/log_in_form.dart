import 'package:flutter/material.dart';
import 'package:login_page/presentation/core/resources/border_radius_manager.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';
import 'package:login_page/presentation/core/resources/padding_margin_value_manager.dart';
import 'package:login_page/presentation/core/resources/size_value_manager.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('login'),
      children: [
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
                  width: WidthValueManager.vW1_5),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorValueManager.vBlack45Color),
            ),
          ),
        ),
        const SizedBox(height: HeightValueManager.vH20),
        TextField(
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
                  width: WidthValueManager.vW1_5),
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
