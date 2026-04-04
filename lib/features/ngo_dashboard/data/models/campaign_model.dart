// lib/features/ngo_dashboard/models/campaign_model.dart
class CampaignModel {
  final String id;
  final String ngoId;
  final String title;
  final String description;
  final double goalAmount;
  final double raisedAmount;
  final DateTime deadline;
  final bool active;
  final bool impactVerified;
  final String? impactProofUrl;
  final String? outcomeUpdate;
  final DateTime createdAt;

  CampaignModel({
    required this.id,
    required this.ngoId,
    required this.title,
    required this.description,
    required this.goalAmount,
    required this.raisedAmount,
    required this.deadline,
    required this.active,
    required this.impactVerified,
    this.impactProofUrl,
    this.outcomeUpdate,
    required this.createdAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) => CampaignModel(
    id: json['id'],
    ngoId: json['ngoId'],
    title: json['title'],
    description: json['description'],
    goalAmount: json['goalAmount'].toDouble(),
    raisedAmount: json['raisedAmount'].toDouble(),
    deadline: DateTime.parse(json['deadline']),
    active: json['active'],
    impactVerified: json['impactVerified'] ?? false,
    impactProofUrl: json['impactProofUrl'],
    outcomeUpdate: json['outcomeUpdate'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}