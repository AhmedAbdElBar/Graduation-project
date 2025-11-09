import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'color_codes_dialog.dart';
import 'color_blind_dialog.dart';

class CustomContainerForHomePage extends StatefulWidget {
  final int index;

  const CustomContainerForHomePage({super.key, required this.index});

  @override
  State<CustomContainerForHomePage> createState() =>
      _CustomContainerForHomePageState();
}

class _CustomContainerForHomePageState extends State<CustomContainerForHomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Color> colors = [];
  bool isLoading = true;

  bool favorite = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    fetchPalette();
  }

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

        _controller.forward(from: 0); // شغل الأنيميشن
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
        return ColorCodesDialog(
          colors: colors,
          colorCodes: colorCodes,
          onFavoritePressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to favorites!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          onColorBlindPressed: () {
            Navigator.of(context).pop(); // اغلق الـ dialog الحالي
            showDialog(
              context: context,
              builder: (context) {
                return ColorBlindDialog(
                  colors: colors,
                );
              },
            );
          },
        );
      },
    );
  }

  // محاكاة أنواع عمى الألوان

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading || (!_controller.isAnimating && _controller.value == 0)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 200,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ✅ قسم الألوان
                  GestureDetector(
                    onTap: colors.isEmpty ? null : showColorCodesDialog,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Column(
                        children: List.generate(4, (i) {
                          return Container(
                            height: i == 0
                                ? 60
                                : i == 1
                                    ? 40
                                    : i == 2
                                        ? 30
                                        : 25,
                            color: colors[i],
                          );
                        }),
                      ),
                    ),
                  ),

                  // ✅ قسم المعلومات تحت الألوان
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    IconButton(
                        icon: Icon(
                            favorite ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: favorite ? Colors.red : Colors.grey),
                        onPressed: () {
                          setState(() {
                            favorite = !favorite;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(favorite
                                  ? 'Added to favorites!'
                                  : 'Removed from favorites!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
