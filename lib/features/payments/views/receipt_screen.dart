// lib/features/payment/views/receipt_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/payment_providers.dart';

class ReceiptScreen extends ConsumerWidget {
  final String donationId;
  const ReceiptScreen({super.key, required this.donationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptAsync = ref.watch(receiptProvider(donationId));
    return Scaffold(
      appBar: AppBar(title: const Text('Donation Receipt'), backgroundColor: const Color(0xFF7C3AED)),
      body: receiptAsync.when(
        data: (donation) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.receipt, size: 60, color: Color(0xFF7C3AED)),
              const SizedBox(height: 20),
              _infoRow('Donation ID', donation.id),
              _infoRow('Amount', '₹${donation.amount.toStringAsFixed(2)}'),
              _infoRow('Campaign ID', donation.campaignId),
              _infoRow('NGO ID', donation.ngoId),
              _infoRow('Date', '${donation.createdAt.toLocal()}'),
              _infoRow('Status', donation.verified ? '✅ Verified' : '⚠️ Pending'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}