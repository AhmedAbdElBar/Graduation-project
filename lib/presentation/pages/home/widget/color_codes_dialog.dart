import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';

class ColorCodesDialog extends StatelessWidget {
  final List<Color> colors;
  final List<String> colorCodes;
  final VoidCallback onFavoritePressed;
  final VoidCallback onColorBlindPressed;

  const ColorCodesDialog({
    super.key,
    required this.colors,
    required this.colorCodes,
    required this.onFavoritePressed,
    required this.onColorBlindPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorValueManager.vWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        'Palette',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < colors.length - 1; i++)
            ListTile(
              leading: CircleAvatar(backgroundColor: colors[i]),
              title: Text(
                colorCodes[i],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: colorCodes[i]));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${colorCodes[i]} copied!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onColorBlindPressed,
          child: const Text(
            'Color Blind Simulation',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
