// lib/features/admin_dashboard/data/admin_repository.dart


import '../model/analytics_model.dart';
import '../model/campaign_impact_model.dart';
import '../model/fraud_report_model.dart';
import '../model/ngo_verification_model.dart';
import '../services/admin_service.dart';

class AdminRepository {
  final AdminService _service = AdminService();

  Future<AnalyticsModel> getAnalytics() => _service.getAnalytics();
  Future<List<NgoVerificationModel>> getPendingVerifications() => _service.getPendingVerifications();
  Future<NgoVerificationModel> approveNgo(String ngoProfileId) => _service.approveNgo(ngoProfileId);
  Future<NgoVerificationModel> rejectNgo(String ngoProfileId, String reason) => _service.rejectNgo(ngoProfileId, reason);
  Future<List<FraudReportModel>> getPendingFraudReports() => _service.getPendingFraudReports();
  Future<void> dismissReport(String reportId) => _service.dismissReport(reportId);
  Future<void> warnNgo(String reportId) => _service.warnNgo(reportId);
  Future<void> removeNgo(String reportId) => _service.removeNgo(reportId);
  Future<List<CampaignImpactModel>> getCampaignsForImpactVerification() => _service.getCampaignsForImpactVerification();
  Future<void> verifyCampaignImpact(String campaignId) => _service.verifyCampaignImpact(campaignId);
}