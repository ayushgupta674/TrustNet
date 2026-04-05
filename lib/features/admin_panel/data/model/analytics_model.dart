// lib/features/admin_dashboard/models/analytics_model.dart
class AnalyticsModel {
  final int totalNgos;
  final int verifiedNgos;
  final int pendingNgos;
  final int rejectedNgos;
  final int totalDonors;
  final int totalDonations;
  final double totalAmountRaised;
  final int totalCampaigns;
  final int activeCampaigns;
  final int totalVolunteerPosts;
  final int totalFraudReports;
  final int pendingFraudReports;

  AnalyticsModel({
    required this.totalNgos,
    required this.verifiedNgos,
    required this.pendingNgos,
    required this.rejectedNgos,
    required this.totalDonors,
    required this.totalDonations,
    required this.totalAmountRaised,
    required this.totalCampaigns,
    required this.activeCampaigns,
    required this.totalVolunteerPosts,
    required this.totalFraudReports,
    required this.pendingFraudReports,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) => AnalyticsModel(
    totalNgos: json['totalNgos'],
    verifiedNgos: json['verifiedNgos'],
    pendingNgos: json['pendingNgos'],
    rejectedNgos: json['rejectedNgos'],
    totalDonors: json['totalDonors'],
    totalDonations: json['totalDonations'],
    totalAmountRaised: json['totalAmountRaised'].toDouble(),
    totalCampaigns: json['totalCampaigns'],
    activeCampaigns: json['activeCampaigns'],
    totalVolunteerPosts: json['totalVolunteerPosts'],
    totalFraudReports: json['totalFraudReports'],
    pendingFraudReports: json['pendingFraudReports'],
  );
}