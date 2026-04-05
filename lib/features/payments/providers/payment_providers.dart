// lib/features/payment/providers/payment_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/donation_request.dart';
import '../data/model/donation_response.dart';
import '../data/repository/payment_repository.dart';


final paymentRepositoryProvider = Provider((ref) => PaymentRepository());

final initiateDonationProvider = FutureProvider.family<Map<String, dynamic>, InitiateDonationRequest>((ref, request) async {
  final repo = ref.read(paymentRepositoryProvider);
  return repo.initiateDonation(request);
});

final verifyDonationProvider = FutureProvider.family<DonationModel, VerifyDonationRequest>((ref, request) async {
  final repo = ref.read(paymentRepositoryProvider);
  return repo.verifyDonation(request);
});

final receiptProvider = FutureProvider.family<DonationModel, String>((ref, donationId) async {
  final repo = ref.read(paymentRepositoryProvider);
  return repo.getReceipt(donationId);
});