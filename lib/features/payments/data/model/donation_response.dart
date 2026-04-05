// lib/features/payment/models/donation_response.dart
class DonationModel {
  final String id;
  final String donorId;
  final String ngoId;
  final String campaignId;
  final double amount;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final bool verified;
  final DateTime createdAt;

  DonationModel({
    required this.id,
    required this.donorId,
    required this.ngoId,
    required this.campaignId,
    required this.amount,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.verified,
    required this.createdAt,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) => DonationModel(
    id: json['id'],
    donorId: json['donorId'],
    ngoId: json['ngoId'],
    campaignId: json['campaignId'],
    amount: json['amount'].toDouble(),
    razorpayOrderId: json['razorpayOrderId'],
    razorpayPaymentId: json['razorpayPaymentId'],
    verified: json['verified'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}