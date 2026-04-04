// lib/features/shorts/views/shorts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trust_net/features/home/views/posts_feed_tab.dart';
import '../../../features/home/views/donor_profile_screen.dart';
import '../../../features/explore/views/explore_screen.dart';
import '../providers/shorts_provider.dart';
import '../widgets/shorts_bottom_navbar.dart';
import '../widgets/shorts_card.dart';

class ShortsScreen extends ConsumerWidget {
  const ShortsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(bottomTabIndexProvider);
    final shortsAsync = ref.watch(shortsProvider);

    return Scaffold(
      body: IndexedStack(
        index: tabIndex,
        children: [
          // Tab 0: Home – scrollable feed
          const HomeFeedTab(),
          // Tab 1: Shorts – vertical PageView
          shortsAsync.when(
            data: (shorts) => PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: shorts.length,
              itemBuilder: (context, index) => ShortPageItem(short: shorts[index]),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
          // Tab 2: Explore
          const ExploreScreen(),
          // Tab 3: Profile
          const DonorProfileScreen(),
        ],
      ),
      bottomNavigationBar: ShortBottomNavBar(
        currentIndex: tabIndex,
        onTap: (index) => ref.read(bottomTabIndexProvider.notifier).state = index,
      ),
    );
  }
}