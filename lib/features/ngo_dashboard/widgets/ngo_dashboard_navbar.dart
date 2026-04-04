import 'package:flutter/material.dart';

class NgoDashboardBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NgoDashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF7C3AED),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined),
          label: 'Create',
          activeIcon: Icon(Icons.add_box),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
          activeIcon: Icon(Icons.person),
        ),
      ],
    );
  }
}