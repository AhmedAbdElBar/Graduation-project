import 'package:flutter/material.dart';
import '../../../core/resources/border_radius_manager.dart';
import '../../../core/resources/color_value_manager.dart';
import '../../../core/resources/padding_margin_value_manager.dart';
import '../../../core/resources/size_value_manager.dart';
import '../../../core/resources/strings_value_manager.dart';
import '../widgets/log_in_form.dart';
import '../widgets/sign_up_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const String routeName = "OnBoardingScreen";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValueManager.vWhiteColor,
      body: Padding(
        padding: PaddingValueManager.eAll30,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: PaddingValueManager.eAll30,
              height: HeightValueManager.vH452,
              decoration: BoxDecoration(
                color: ColorValueManager.vWhiteColor,
                borderRadius: BorderRadius.circular(
                  RadiusValueManager.vBR15,
                ),
                border: Border.all(
                  color: ColorValueManager.vGrayColor,
                  width: WidthValueManager.vW1_5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: ColorValueManager
                        .vBlack26Color, // Shadow color with opacity
                    spreadRadius: 2, // How wide the shadow spreads
                    blurRadius: 8, // How soft the shadow looks
                    offset: Offset(0, 4), // Horizontal + Vertical offset
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: PaddingValueManager.eAll15,
                    child: Container(
                      width: WidthValueManager.vW250,
                      decoration: BoxDecoration(
                        color: ColorValueManager.vBajColor,
                        borderRadius: RadiusValueManager.vBR100,
                        border: Border.all(
                          color: ColorValueManager.vGrayColor,
                          width: WidthValueManager.vW1_5,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Log In Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: PaddingValueManager.vP10,
                                ),
                                decoration: BoxDecoration(
                                  color: isLogin
                                      ? ColorValueManager.vGrayColor
                                      : ColorValueManager.vBajColor,
                                  borderRadius: RadiusValueManager.vBR100,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  StringsValueManager.vLoginButton,
                                  style: TextStyle(
                                    color: isLogin
                                        ? ColorValueManager.vWhiteColor
                                        : ColorValueManager.vGrayColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Sign Up Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: PaddingValueManager.vP10,
                                ),
                                decoration: BoxDecoration(
                                  color: !isLogin
                                      ? ColorValueManager.vGrayColor
                                      : ColorValueManager.vBajColor,
                                  borderRadius: RadiusValueManager.vBR100,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  StringsValueManager.vSignUpButton,
                                  style: TextStyle(
                                    color: !isLogin
                                        ? ColorValueManager.vWhiteColor
                                        : ColorValueManager.vGrayColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: HeightValueManager.vH20),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isLogin ? const LoginForm() : const SignUpForm(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
