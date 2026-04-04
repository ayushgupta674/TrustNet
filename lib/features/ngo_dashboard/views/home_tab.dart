// lib/features/ngo_dashboard/views/home_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ngo_dashboard_providers.dart';
import '../widgets/campaign_card.dart';
import '../widgets/post_card.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsync = ref.watch(ngoCampaignsProvider);
    final postsAsync = ref.watch(ngoPostsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 20), // 👈 top padding added
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'My Campaigns',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          campaignsAsync.when(
            data: (campaigns) => Column(
              children: campaigns
                  .map((c) => CampaignCard(campaign: c))
                  .toList(),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text('Error: $err')),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Recent Posts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          postsAsync.when(
            data: (posts) => Column(
              children: posts.map((p) => PostCard(post: p)).toList(),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}