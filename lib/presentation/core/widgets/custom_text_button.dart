import 'package:flutter/material.dart';
import '../resources/color_value_manager.dart';

class CustomTextButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback function;
  const CustomTextButton(
      {super.key,
      required this.color,
      required this.title,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      child: Text(
        title,
        style: TextStyle(
            color: color,
            decoration: TextDecoration.underline,
            decorationColor: ColorValueManager.vPrimaryColor),
      ),
    );
  }
}
