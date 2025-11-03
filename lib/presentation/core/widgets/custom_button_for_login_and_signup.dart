import "package:flutter/material.dart";
import '../resources/color_value_manager.dart';
import '../resources/fonts_value_manager.dart';
import '../resources/size_value_manager.dart';
import '../resources/border_radius_manager.dart';

class CustomButtonForLoginAndSignup extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const CustomButtonForLoginAndSignup({
    super.key,
    required this.title,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: HeightValueManager.vH50,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorValueManager.vPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusValueManager.vBR10),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: ColorValueManager.vWhiteColor,
            fontWeight: FontWeight.bold,
            fontSize: FontSizeValueManager.vFS16,
          ),
        ),
      ),
    );
  }
}
