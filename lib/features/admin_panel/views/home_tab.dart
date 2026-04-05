// lib/features/admin_dashboard/views/home_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admin_provider.dart';
import '../widgets/analytics_card.dart';
import '../widgets/verification_card.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);
    return analyticsAsync.when(
      data: (analytics) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                AnalyticsCard(title: 'Total NGOs', value: '${analytics.totalNgos}', icon: Icons.business, color: Colors.blue),
                AnalyticsCard(title: 'Verified NGOs', value: '${analytics.verifiedNgos}', icon: Icons.verified, color: Colors.green),
                AnalyticsCard(title: 'Pending NGOs', value: '${analytics.pendingNgos}', icon: Icons.hourglass_empty, color: Colors.orange),
                AnalyticsCard(title: 'Rejected NGOs', value: '${analytics.rejectedNgos}', icon: Icons.cancel, color: Colors.red),
                AnalyticsCard(title: 'Total Donors', value: '${analytics.totalDonors}', icon: Icons.people, color: Colors.purple),
                AnalyticsCard(title: 'Donations', value: '${analytics.totalDonations}', icon: Icons.money, color: Colors.teal),
                AnalyticsCard(title: 'Amount Raised', value: '₹${analytics.totalAmountRaised}', icon: Icons.currency_rupee, color: Colors.amber),
                AnalyticsCard(title: 'Campaigns', value: '${analytics.totalCampaigns}', icon: Icons.campaign, color: Colors.indigo),
                AnalyticsCard(title: 'Active Campaigns', value: '${analytics.activeCampaigns}', icon: Icons.play_circle, color: Colors.green),
                AnalyticsCard(title: 'Volunteer Posts', value: '${analytics.totalVolunteerPosts}', icon: Icons.volunteer_activism, color: Colors.pink),
                AnalyticsCard(title: 'Fraud Reports', value: '${analytics.totalFraudReports}', icon: Icons.report, color: Colors.red),
                AnalyticsCard(title: 'Pending Reports', value: '${analytics.pendingFraudReports}', icon: Icons.pending, color: Colors.orange),
              ],
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}