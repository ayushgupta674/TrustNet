// lib/features/admin_dashboard/widgets/verification_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/ngo_verification_model.dart';
import '../providers/admin_provider.dart';


class VerificationCard extends ConsumerWidget {
  final NgoVerificationModel ngo;

  const VerificationCard({super.key, required this.ngo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ngo.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Cause: ${ngo.cause}'),
            const SizedBox(height: 4),
            Text('Document: ${ngo.registrationDocumentUrl}'),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await ref.read(approveNgoProvider(ngo.id).future);
                    if (result != null) {
                      ref.refresh(pendingVerificationsProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('NGO approved!')),
                      );
                    }
                  },
                  child: const Text('Approve'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final reasonController = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Reject NGO'),
                        content: TextField(
                          controller: reasonController,
                          decoration: const InputDecoration(hintText: 'Rejection reason'),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await ref.read(rejectNgoProvider((ngoId: ngo.id, reason: reasonController.text)).future);
                              ref.refresh(pendingVerificationsProvider);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('NGO rejected!')),
                              );
                            },
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}