import 'dart:ui'; // ← مهم للـ BackdropFilter
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

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // انشاء AnimationController
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // تعريف انيميشن للـ Slide من اليمين
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // خارج الشاشة من اليمين
      end: Offset.zero, // مكانه الطبيعي
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeIn),
    );

    // تشغيل الانيميشن مباشرة عند ظهور الشاشة
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValueManager.vWhiteColor,
      body: Stack(
        children: [
          // الخلفية
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/Animation 3.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: PaddingValueManager.eAll30,
            child: Center(
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusValueManager.vBR15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: SlideTransition(
                      position: _slideAnimation, // هنا الانيميشن
                      child: Container(
                        padding: PaddingValueManager.eAll30,
                        height: HeightValueManager.vH452,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(RadiusValueManager.vBR15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: WidthValueManager.vW1_5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // الزرين
                            Padding(
                              padding: PaddingValueManager.eAll15,
                              child: Container(
                                width: WidthValueManager.vW250,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: RadiusValueManager.vBR100,
                                  border: Border.all(
                                    color: ColorValueManager.vWhiteColor,
                                    width: WidthValueManager.vW1_5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Log In Button
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            setState(() => isLogin = true),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: PaddingValueManager.vP10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isLogin
                                                ? ColorValueManager.vWhiteColor
                                                : Colors.transparent,
                                            borderRadius:
                                                RadiusValueManager.vBR100,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            StringsValueManager.vLoginButton,
                                            style: TextStyle(
                                              color: isLogin
                                                  ? ColorValueManager
                                                      .vBlackColor
                                                  : ColorValueManager
                                                      .vWhiteColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Sign Up Button
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            setState(() => isLogin = false),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: PaddingValueManager.vP10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: !isLogin
                                                ? ColorValueManager.vWhiteColor
                                                : Colors.transparent,
                                            borderRadius:
                                                RadiusValueManager.vBR100,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            StringsValueManager.vSignUpButton,
                                            style: TextStyle(
                                              color: !isLogin
                                                  ? ColorValueManager
                                                      .vBlackColor
                                                  : ColorValueManager
                                                      .vWhiteColor,
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
                            // الفورم المتحرك
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: isLogin
                                    ? const LoginForm()
                                    : const SignUpForm(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
