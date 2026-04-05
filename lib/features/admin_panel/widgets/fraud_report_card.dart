// lib/features/admin_dashboard/widgets/fraud_report_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/fraud_report_model.dart';
import '../providers/admin_provider.dart';


class FraudReportCard extends ConsumerWidget {
  final FraudReportModel report;

  const FraudReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reporter: ${report.reporterId}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('NGO ID: ${report.ngoId}'),
            const SizedBox(height: 4),
            Text('Reason: ${report.reason}'),
            const SizedBox(height: 4),
            Text('Date: ${report.createdAt.toLocal()}'),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(dismissReportProvider(report.id).future);
                    ref.invalidate(pendingFraudReportsProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report dismissed')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Dismiss'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(warnNgoProvider(report.id).future);
                    ref.invalidate(pendingFraudReportsProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('NGO warned')),
                    );
                  },
                  child: const Text('Warn'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(removeNgoProvider(report.id).future);
                    ref.invalidate(pendingFraudReportsProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('NGO removed')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Remove NGO'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}