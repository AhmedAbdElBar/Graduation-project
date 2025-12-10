import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    _checkIfFavorite(); // ✅ تحقق من المفضلات عند البداية
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');

    final colorCodes = widget.colors.map((c) {
      String hex = c.value.toRadixString(16).toUpperCase().padLeft(8, '0');
      return '#${hex.substring(2)}';
    }).toList();

    final existing = await favRef.where('colors', isEqualTo: colorCodes).get();

    if (!mounted) return;
    setState(() {
      favorite = existing.docs.isNotEmpty;
    });
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: SizedBox(
                        child: Column(
                          children: List.generate(5, (i) {
                            return Container(
                              height: i == 0
                                  ? 60
                                  : i == 1
                                      ? 40
                                      : i == 2
                                          ? 30
                                          : i == 3
                                              ? 25
                                              : 20,
                              color: widget.colors[i],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(15)),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                        left: BorderSide(color: Colors.grey.shade300),
                        right: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    alignment: Alignment.center,
                    height: 45,
                    child: IconButton(
                      icon: Icon(
                        favorite ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: favorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please log in first!')),
                          );
                          return;
                        }

                        setState(() => favorite = !favorite);

                        final favRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('favorites');

                        final colorCodes = widget.colors.map((c) {
                          String hex = c.value
                              .toRadixString(16)
                              .toUpperCase()
                              .padLeft(8, '0');
                          return '#${hex.substring(2)}';
                        }).toList();

                        if (favorite) {
                          // إضافة إلى المفضلات
                          await favRef.add({
                            'colors': colorCodes,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Added to favorites!')),
                          );
                        } else {
                          // حذف من المفضلات
                          final existing = await favRef
                              .where('colors', isEqualTo: colorCodes)
                              .get();
                          for (var doc in existing.docs) {
                            await doc.reference.delete();
                          }
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Removed from favorites!')),
                          );
                        }
                      },
                    ),
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
