// lib/features/admin_dashboard/views/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_nav_bar.dart';
import 'action_tab.dart';
import 'home_tab.dart';
import 'profile_tab.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(adminTabIndexProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard'), backgroundColor: const Color(0xFF7C3AED)),
      body: IndexedStack(
        index: tabIndex,
        children: const [
          HomeTab(),
          ActionsTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: tabIndex,
        onTap: (index) => ref.read(adminTabIndexProvider.notifier).state = index,
      ),
    );
  }
}