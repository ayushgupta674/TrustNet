// lib/features/ngo_dashboard/views/ngo_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ngo_dashboard_providers.dart';
import '../widgets/ngo_dashboard_navbar.dart';
import 'home_tab.dart';
import 'create_tab.dart';
import 'profile_tab.dart';

class NgoDashboardScreen extends ConsumerWidget {
  const NgoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(ngoDashboardTabIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Dashboard'),
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 0,
        centerTitle: false,
      ),
      body: IndexedStack(
        index: tabIndex,
        children: const [
          HomeTab(),
          CreateTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: NgoDashboardBottomNav(
        currentIndex: tabIndex,
        onTap: (index) =>
        ref.read(ngoDashboardTabIndexProvider.notifier).state = index,
      ),
    );
  }
}