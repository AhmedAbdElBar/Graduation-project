import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CustomContainerForHomePage extends StatefulWidget {
  final int index;

  const CustomContainerForHomePage({super.key, required this.index});

  @override
  State<CustomContainerForHomePage> createState() =>
      _CustomContainerForHomePageState();
}

class _CustomContainerForHomePageState
    extends State<CustomContainerForHomePage> {
  List<Color> colors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPalette();
  }

  // 🧠 دالة جلب الألوان من Colormind API
  Future<void> fetchPalette() async {
    try {
      final response = await http.post(
        Uri.parse('http://colormind.io/api/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'model': 'default'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List result = data['result'];
        setState(() {
          colors = result
              .map((rgb) => Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching palette: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showColorCodesDialog() {
    final List<String> colorCodes = colors.map((color) {
      String hex = color.value.toRadixString(16).toUpperCase().padLeft(8, '0');
      return '#${hex.substring(2)}';
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            '🎨 Palette ${widget.index + 1}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < colors.length; i++)
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: colors.isEmpty ? null : showColorCodesDialog,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isLoading ? Colors.grey[200] : null,
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: List.generate(colors.length, (i) {
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors[i],
                          borderRadius: BorderRadius.only(
                            topLeft: i == 0
                                ? const Radius.circular(15)
                                : Radius.zero,
                            bottomLeft: i == 0
                                ? const Radius.circular(15)
                                : Radius.zero,
                            topRight: i == colors.length - 1
                                ? const Radius.circular(15)
                                : Radius.zero,
                            bottomRight: i == colors.length - 1
                                ? const Radius.circular(15)
                                : Radius.zero,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
        ),
      ),
    );
  }
}
