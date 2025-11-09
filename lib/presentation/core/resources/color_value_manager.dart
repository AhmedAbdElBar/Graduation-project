import 'package:flutter/material.dart';

class ColorValueManager {
  static const Color vPrimaryColor = Colors.deepOrange;
  static const Color vPrimaryColor100 = Color.fromRGBO(255, 204, 188, 1);
  static const Color vWhiteColor = Colors.white;
  static const Color vBlackColor = Colors.black;
  static const Color vBlack45Color = Colors.black45;
  static const Color vBlack26Color = Colors.black26;
  static const Color vDarkBlueColor = Colors.indigo;
  static const Color vBajColor = Color(0xffffffff);
  static const Color vGrayColor = Color(0xff766F6F);

  static const Color vGrayColor300 = Color.fromRGBO(224, 224, 224, 1);
  static const Color vBackgroundColor = Color.fromRGBO(253, 253, 253, 1);
}

class ColorBlindSimulator {
  static Color protanopia(Color color) {
    int r = (color.red * 0.566 + color.green * 0.433).toInt();
    int g = (color.red * 0.558 + color.green * 0.442).toInt();
    int b = color.blue;
    return Color.fromRGBO(r, g, b, 1);
  }

  static Color deuteranopia(Color color) {
    int r = (color.red * 0.625 + color.green * 0.375).toInt();
    int g = (color.red * 0.7 + color.green * 0.3).toInt();
    int b = color.blue;
    return Color.fromRGBO(r, g, b, 1);
  }

  static Color tritanopia(Color color) {
    int r = color.red;
    int g = (color.green * 0.95 + color.blue * 0.05).toInt();
    int b = (color.green * 0.05 + color.blue * 0.95).toInt();
    return Color.fromRGBO(r, g, b, 1);
  }
}

