import 'package:flutter/material.dart';
import '../../../core/resources/color_value_manager.dart';
import '../../../core/resources/size_value_manager.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String labelInFocus;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData prefixIcon;
  final bool isPassword;
  final bool? obscureText;
  final Function(bool)? onObscureToggle;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.labelInFocus,
    required this.keyboardType,
    required this.textInputAction,
    this.isPassword = false,
    this.obscureText,
    this.onObscureToggle,
    required this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      cursorColor: ColorValueManager.vWhiteColor,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: const TextStyle(color: ColorValueManager.vWhiteColor),
      obscureText: widget.isPassword ? (widget.obscureText ?? true) : false,
      decoration: InputDecoration(
        labelText: _isFocused ? widget.labelInFocus : widget.label,
        labelStyle: const TextStyle(color: ColorValueManager.vWhiteColor),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorValueManager.vWhiteColor,
            width: WidthValueManager.vW1_5,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorValueManager.vWhiteColor),
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: ColorValueManager.vWhiteColor,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  (widget.obscureText ?? true)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: ColorValueManager.vWhiteColor,
                ),
                onPressed: () {
                  if (widget.onObscureToggle != null) {
                    widget.onObscureToggle!(!(widget.obscureText ?? true));
                  }
                },
              )
            : null,
      ),
    );
  }
}
