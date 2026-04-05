// lib/features/admin_dashboard/models/fraud_report_model.dart
class FraudReportModel {
  final String id;
  final String reporterId;
  final String ngoId;
  final String reason;
  final String status;
  final String? adminAction;
  final DateTime createdAt;

  FraudReportModel({
    required this.id,
    required this.reporterId,
    required this.ngoId,
    required this.reason,
    required this.status,
    this.adminAction,
    required this.createdAt,
  });

  factory FraudReportModel.fromJson(Map<String, dynamic> json) => FraudReportModel(
    id: json['id'],
    reporterId: json['reporterId'],
    ngoId: json['ngoId'],
    reason: json['reason'],
    status: json['status'],
    adminAction: json['adminAction'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}