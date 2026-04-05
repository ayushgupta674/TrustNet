// lib/features/admin_dashboard/widgets/impact_verification_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/campaign_impact_model.dart';
import '../providers/admin_provider.dart';


class ImpactVerificationCard extends ConsumerWidget {
  final CampaignImpactModel campaign;

  const ImpactVerificationCard({super.key, required this.campaign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(campaign.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('NGO: ${campaign.ngoName}'),
            const SizedBox(height: 4),
            Text('Goal: ₹${campaign.goalAmount} | Raised: ₹${campaign.raisedAmount}'),
            const SizedBox(height: 4),
            if (campaign.impactProofUrl != null)
              GestureDetector(
                onTap: () {
                  // Open URL in browser
                },
                child: Text('Proof URL: ${campaign.impactProofUrl}', style: const TextStyle(color: Colors.blue)),
              ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await ref.read(verifyCampaignImpactProvider(campaign.id).future);
                ref.invalidate(pendingImpactCampaignsProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Campaign impact verified!')),
                );
              },
              child: const Text('Verify Impact'),
            ),
          ],
        ),
      ),
    );
  }
}