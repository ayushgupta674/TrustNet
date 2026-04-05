// lib/features/admin_dashboard/providers/admin_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/analytics_model.dart';
import '../data/model/campaign_impact_model.dart';
import '../data/model/fraud_report_model.dart';
import '../data/model/ngo_verification_model.dart';
import '../data/repositories/admin_repository.dart';

final adminRepositoryProvider = Provider((ref) => AdminRepository());

// Analytics
final analyticsProvider = FutureProvider<AnalyticsModel>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getAnalytics();
});

// Pending Verifications
final pendingVerificationsProvider = FutureProvider<List<NgoVerificationModel>>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getPendingVerifications();
});

// Pending Fraud Reports
final pendingFraudReportsProvider = FutureProvider<List<FraudReportModel>>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getPendingFraudReports();
});

// Pending Impact Verifications
final pendingImpactCampaignsProvider = FutureProvider<List<CampaignImpactModel>>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getCampaignsForImpactVerification();
});

// Action providers (for refresh after approve/reject)
final approveNgoProvider = FutureProvider.family<NgoVerificationModel, String>((ref, ngoId) async {
  final repo = ref.read(adminRepositoryProvider);
  return repo.approveNgo(ngoId);
});

final rejectNgoProvider = FutureProvider.family<NgoVerificationModel, ({String ngoId, String reason})>((ref, params) async {
  final repo = ref.read(adminRepositoryProvider);
  return repo.rejectNgo(params.ngoId, params.reason);
});

final dismissReportProvider = FutureProvider.family<void, String>((ref, reportId) async {
  final repo = ref.read(adminRepositoryProvider);
  await repo.dismissReport(reportId);
});

final warnNgoProvider = FutureProvider.family<void, String>((ref, reportId) async {
  final repo = ref.read(adminRepositoryProvider);
  await repo.warnNgo(reportId);
});

final removeNgoProvider = FutureProvider.family<void, String>((ref, reportId) async {
  final repo = ref.read(adminRepositoryProvider);
  await repo.removeNgo(reportId);
});

final verifyCampaignImpactProvider = FutureProvider.family<void, String>((ref, campaignId) async {
  final repo = ref.read(adminRepositoryProvider);
  await repo.verifyCampaignImpact(campaignId);
});

// Bottom navigation index
final adminTabIndexProvider = StateProvider<int>((ref) => 0);
// Sub-tab index inside Actions tab
final adminActionsSubTabProvider = StateProvider<int>((ref) => 0);