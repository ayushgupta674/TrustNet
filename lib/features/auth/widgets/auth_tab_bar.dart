// lib/features/auth/widgets/auth_tab_bar.dart
import 'package:flutter/material.dart';

class AuthTabBar extends StatelessWidget {
  final TabController tabController;

  const AuthTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(32),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF7C3AED),
          borderRadius: BorderRadius.circular(32),
        ),
        indicatorSize: TabBarIndicatorSize.tab, // 👈 Makes indicator fill the full tab
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade700,
        labelPadding: EdgeInsets.zero, // 👈 Removes extra padding around text
        tabs: const [
          Tab(text: 'NGO'),
          Tab(text: 'Donor'),
        ],
      ),
    );
  }
}