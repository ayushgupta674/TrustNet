// lib/features/payment/data/payment_repository.dart


import '../model/donation_request.dart';
import '../model/donation_response.dart';
import '../service/payment_service.dart';

class PaymentRepository {
  final PaymentService _service = PaymentService();

  Future<Map<String, dynamic>> initiateDonation(InitiateDonationRequest request) =>
      _service.initiateDonation(request);

  Future<DonationModel> verifyDonation(VerifyDonationRequest request) =>
      _service.verifyDonation(request);

  Future<DonationModel> getReceipt(String donationId) =>
      _service.getReceipt(donationId);
}