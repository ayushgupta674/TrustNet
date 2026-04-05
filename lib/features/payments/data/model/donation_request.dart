// lib/features/payment/models/donation_request.dart
class InitiateDonationRequest {
  final String ngoId;
  final String campaignId;
  final double amount;

  InitiateDonationRequest({
    required this.ngoId,
    required this.campaignId,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'ngoId': ngoId,
    'campaignId': campaignId,
    'amount': amount,
  };
}

class VerifyDonationRequest {
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String signature;

  VerifyDonationRequest({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.signature,
  });

  Map<String, dynamic> toJson() => {
    'razorpayOrderId': razorpayOrderId,
    'razorpayPaymentId': razorpayPaymentId,
    'signature': signature,
  };
}