// lib/features/shorts/widgets/shorts_bottom_navbar.dart
import 'package:flutter/material.dart';

class ShortBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ShortBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF7C3AED),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home', activeIcon: Icon(Icons.home)),
        BottomNavigationBarItem(icon: Icon(Icons.video_library_outlined), label: 'Shorts', activeIcon: Icon(Icons.video_library)),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore', activeIcon: Icon(Icons.explore)),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile', activeIcon: Icon(Icons.person)),
      ],
    );
  }
}