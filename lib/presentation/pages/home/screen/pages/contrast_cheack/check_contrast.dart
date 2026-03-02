import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for input formatting

class ContrastCheckerScreen extends StatefulWidget {
  const ContrastCheckerScreen({super.key});

  @override
  State<ContrastCheckerScreen> createState() => _ContrastCheckerScreenState();
}

class _ContrastCheckerScreenState extends State<ContrastCheckerScreen> {
  // Use ValueNotifier for live updates on text change
  final ValueNotifier<String> textColorHex = ValueNotifier<String>("#000000");
  final ValueNotifier<String> bgColorHex = ValueNotifier<String>("#ffffff");

  // Keep internal controllers for input fields
  final TextEditingController textColorController =
      TextEditingController(text: "#000000");
  final TextEditingController bgColorController =
      TextEditingController(text: "#ffffff");

  double? contrastRatio;
  String? wcagLevel;

  @override
  void initState() {
    super.initState();
    // Add listeners to update the ValueNotifiers and re-check contrast on every change
    textColorController.addListener(_onColorInputChange);
    bgColorController.addListener(_onColorInputChange);
    _checkContrast(initial: true);
  }

  @override
  void dispose() {
    textColorController.removeListener(_onColorInputChange);
    bgColorController.removeListener(_onColorInputChange);
    textColorController.dispose();
    bgColorController.dispose();
    textColorHex.dispose();
    bgColorHex.dispose();
    super.dispose();
  }

  void _onColorInputChange() {
    textColorHex.value = textColorController.text;
    bgColorHex.value = bgColorController.text;
    _checkContrast();
  }

  Color _parseColor(String hex) {
    hex = hex.replaceAll("#", "").toUpperCase();
    if (hex.length == 6) {
      return Color(int.parse("FF$hex", radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    }
    // Return a default color (e.g., red for error) if parsing fails
    return Colors.red;
  }

  double _luminance(Color color) {
    double r = color.red / 255.0;
    double g = color.green / 255.0;
    double b = color.blue / 255.0;

    // Linearizing RGB (standard sRGB to linear RGB conversion)
    r = (r <= 0.03928) ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4).toDouble();
    g = (g <= 0.03928) ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4).toDouble();
    b = (b <= 0.03928) ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4).toDouble();

    // Standard Luminance Formula
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  double _contrastRatio(Color color1, Color color2) {
    final lum1 = _luminance(color1);
    final lum2 = _luminance(color2);
    final brightest = max(lum1, lum2);
    final darkest = min(lum1, lum2);
    return (brightest + 0.05) / (darkest + 0.05);
  }

  String _wcagLevel(double ratio) {
    if (ratio.isNaN) return "❌ Invalid Color";

    // WCAG 2.1 Compliance Ratios
    if (ratio >= 7.0) return "AAA";
    if (ratio >= 4.5) return "AA";
    if (ratio >= 3.0) return "AA Large Text";
    return "Fail";
  }

  void _checkContrast({bool initial = false}) {
    // Only update if the hex codes are valid, otherwise, the default colors are used.
    final currentTextColorHex = textColorController.text;
    final currentBgColorHex = bgColorController.text;

    // Basic validity check: must start with '#' and be 7 characters long (#RRGGBB)
    final isValidText = currentTextColorHex.startsWith('#') &&
        (currentTextColorHex.length == 7 || currentTextColorHex.length == 9);
    final isValidBg = currentBgColorHex.startsWith('#') &&
        (currentBgColorHex.length == 7 || currentBgColorHex.length == 9);

    if (isValidText && isValidBg) {
      try {
        final textColor = _parseColor(currentTextColorHex);
        final bgColor = _parseColor(currentBgColorHex);

        final ratio = _contrastRatio(textColor, bgColor);
        final level = _wcagLevel(ratio);

        if (initial || ratio != contrastRatio || level != wcagLevel) {
          setState(() {
            contrastRatio = ratio;
            wcagLevel = level;
          });
        }
      } catch (e) {
        setState(() {
          contrastRatio = 1.0; // Default low ratio on error
          wcagLevel = "❌ Invalid Color Format";
        });
      }
    } else if (!initial) {
      setState(() {
        contrastRatio = 1.0; // Default low ratio on error
        wcagLevel = "❌ Invalid HEX Code";
      });
    }
  }

  // --- Helper Widget for the Modern Input Field ---
  Widget _colorInputField({
    required TextEditingController controller,
    required String label,
    required Color color,
  }) {
    // Determine a readable color for the label and cursor based on the background color
    final double luminance = _luminance(color);
    final isDark = luminance < 0.5;
    final readableColor = isDark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: const Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: readableColor, fontWeight: FontWeight.bold),
        cursorColor: readableColor,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          // Enforce HEX format
          FilteringTextInputFormatter.allow(RegExp(r'[#a-fA-F0-9]')),
        ],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: readableColor.withOpacity(0.8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget _resultCard(Color textColor, Color bgColor) {
    Color statusColor;
    switch (wcagLevel) {
      case "AAA":
        statusColor = Colors.green.shade700;
        break;
      case "AA":
        statusColor = Colors.lightBlue.shade700;
        break;
      case "AA Large Text":
        statusColor = Colors.orange.shade700;
        break;
      default:
        statusColor = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Contrast Ratio:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                contrastRatio!.toStringAsFixed(2) + ":1",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const Divider(height: 30),

          const Text(
            "WCAG Compliance:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: statusColor, width: 2),
            ),
            child: Text(
              wcagLevel!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Live Preview:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              "Accessibility Test Text (Ratio: ${contrastRatio!.toStringAsFixed(2)})",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: textColorHex,
      builder: (context, currentTextColorHex, _) {
        final textColor = _parseColor(currentTextColorHex);
        return ValueListenableBuilder<String>(
          valueListenable: bgColorHex,
          builder: (context, currentBgColorHex, __) {
            final bgColor = _parseColor(currentBgColorHex);

            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                title: const Text("WCAG Contrast Checker"),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Colors.black87,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Color Inputs",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 15),

                    _colorInputField(
                      controller: textColorController,
                      label: "Text Color (e.g. #000000)",
                      color: textColor,
                    ),
                    const SizedBox(height: 15),

                    _colorInputField(
                      controller: bgColorController,
                      label: "Background Color (e.g. #ffffff)",
                      color: bgColor,
                    ),
                    const SizedBox(height: 30),

                    if (contrastRatio != null) _resultCard(textColor, bgColor),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
