import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:login_page/presentation/pages/export/screens/extract_page.dart';
import 'package:login_page/presentation/pages/favorites_page/favorites_page.dart';
import 'package:login_page/presentation/pages/home/screen/pages/contrast_cheack/check_contrast.dart';
import 'package:login_page/presentation/pages/home/screen/pages/home_page/home_page.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/homeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const ExtractColorsPage(),
    const FavoritesPage(),
    const ContrastCheckerScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _navItem(IconData icon, int index) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          size: 28,
          color: isSelected
              ? switch (_currentIndex) {
                  0 => Colors.lightBlue,
                  1 => Colors.yellow,
                  2 => Colors.red,
                  3 => Colors.green,
                  _ => Colors.white,
                }
              : Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home, 0),
                  _navItem(Icons.add_box, 1),
                  _navItem(Icons.favorite, 2),
                  _navItem(Icons.color_lens, 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
