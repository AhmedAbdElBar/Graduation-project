import 'package:flutter/material.dart';
import 'color_codes_dialog.dart';
import 'color_blind_dialog.dart';

class CustomContainerForHomePage extends StatefulWidget {
  final int index;
  final List<Color> colors;

  const CustomContainerForHomePage({
    super.key,
    required this.index,
    required this.colors,
  });

  @override
  State<CustomContainerForHomePage> createState() =>
      _CustomContainerForHomePageState();
}

class _CustomContainerForHomePageState extends State<CustomContainerForHomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
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

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward(from: 0);
  }

  void showColorCodesDialog() {
    final List<String> colorCodes = widget.colors.map((color) {
      String hex = color.value.toRadixString(16).toUpperCase().padLeft(8, '0');
      return '#${hex.substring(2)}';
    }).toList();

    showDialog(
      context: context,
      builder: (context) => ColorCodesDialog(
        colors: widget.colors,
        colorCodes: colorCodes,
        onFavoritePressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Added to favorites!'),
                duration: Duration(seconds: 1)),
          );
        },
        onColorBlindPressed: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => ColorBlindDialog(colors: widget.colors),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                  GestureDetector(
                    onTap: showColorCodesDialog,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15)),
                      child: SizedBox(
                        child: Column(
                          children: List.generate(5, (i) {
                            return Container(
                              height: i == 0
                                  ? 55
                                  : i == 1
                                      ? 35
                                      : i == 2
                                          ? 27
                                          : i == 3
                                              ? 20
                                              : 20, // للون الأخير
                              color: widget.colors[i],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: favorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() => favorite = !favorite);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(favorite
                                  ? 'Added to favorites!'
                                  : 'Removed from favorites!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
