import 'package:flutter/material.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';

class ColorBlindDialog extends StatelessWidget {
  final List<Color> colors;

  const ColorBlindDialog({
    super.key,
    required this.colors,
  });

  // simulate Protanopia 
  Color simulateProtanopia(Color color) {
    int r = (color.red * 0.567 + color.green * 0.433).round().clamp(0, 255);
    int g = (color.red * 0.558 + color.green * 0.442).round().clamp(0, 255);
    int b = (color.blue * 0.242 + color.green * 0.758).round().clamp(0, 255);
    return Color.fromARGB(255, r, g, b);
  }

// simulate Deuteranopia
  Color simulateDeuteranopia(Color color) {
    int r = (color.red * 0.625 + color.green * 0.375).round().clamp(0, 255);
    int g = (color.red * 0.7 + color.green * 0.3).round().clamp(0, 255);
    int b = (color.blue * 0.3 + color.green * 0.7).round().clamp(0, 255);
    return Color.fromARGB(255, r, g, b);
  }

// simulate Tritanopia 
  Color simulateTritanopia(Color color) {
    int r = (color.red * 0.95 + color.blue * 0.05).round().clamp(0, 255);
    int g = (color.green * 0.433 + color.red * 0.567).round().clamp(0, 255);
    int b = (color.blue * 0.475 + color.green * 0.525).round().clamp(0, 255);
    return Color.fromARGB(255, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: AlertDialog(
        backgroundColor: ColorValueManager.vWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Color Blind Simulation'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: colors
                      .map((c) => Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: c,
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),

              const TabBar(
                tabs: [
                  Tab(text: 'Protanopia'),
                  Tab(text: 'Deuteranopia'),
                  Tab(text: 'Tritanopia'),
                ],
              ),
              SizedBox(
                height: 120,
                child: TabBarView(
                  children: [
                    Row(
                      children: colors
                          .map((c) => Expanded(
                                child: Container(
                                  color: simulateProtanopia(c),
                                ),
                              ))
                          .toList(),
                    ),
                    Row(
                      children: colors
                          .map((c) => Expanded(
                                child: Container(
                                  color: simulateDeuteranopia(c),
                                ),
                              ))
                          .toList(),
                    ),
                    Row(
                      children: colors
                          .map((c) => Expanded(
                                child: Container(
                                  color: simulateTritanopia(c),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
