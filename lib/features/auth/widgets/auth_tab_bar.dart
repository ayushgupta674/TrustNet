import 'dart:ui';

import 'package:flutter/material.dart';

class AuthTabBar extends StatelessWidget {
  final TabController tabController;

  const AuthTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(40),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            tabs: const [
              Tab(text: 'NGO'),
              Tab(text: 'Donor'),
              Tab(text: 'Admin'),
            ],
          ),
        ),
      ),
    );
  }
}