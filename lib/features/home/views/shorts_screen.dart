// lib/features/shorts/views/shorts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shorts_provider.dart';
import '../widgets/shorts_app_bar.dart';
import '../widgets/shorts_bottom_navbar.dart'; // corrected import (was shorts_card.dart)
import '../../../features/explore/views/explore_screen.dart';
import '../widgets/shorts_card.dart';  // import explore screen

class ShortsScreen extends ConsumerWidget {
  const ShortsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(bottomTabIndexProvider);
    final shortsAsync = ref.watch(shortsProvider);

    return Scaffold(
      appBar: const ShortAppBar(title: 'TrustNet'),
      body: IndexedStack(
        index: tabIndex,
        children: [
          // Tab 0: Home – Vertical PageView of shorts
          shortsAsync.when(
            data: (shorts) => PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: shorts.length,
              itemBuilder: (context, index) => ShortPageItem(short: shorts[index]),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
          // Tab 1: Explore – full Explore screen
          const ExploreScreen(),   // <-- replaced placeholder
          // Tab 2: Profile (placeholder – you can replace with ProfileScreen later)
          const Center(child: Text('Profile Tab - Coming Soon')),
        ],
      ),
      bottomNavigationBar: ShortBottomNavBar(
        currentIndex: tabIndex,
        onTap: (index) => ref.read(bottomTabIndexProvider.notifier).state = index,
      ),
    );
  }
}