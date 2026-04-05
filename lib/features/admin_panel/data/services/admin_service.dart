// lib/features/admin_dashboard/services/admin_service.dart
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../model/analytics_model.dart';
import '../model/campaign_impact_model.dart';
import '../model/fraud_report_model.dart';
import '../model/ngo_verification_model.dart';

class AdminService {
  final DioClient _dio = DioClient();

  // Analytics
  Future<AnalyticsModel> getAnalytics() async {
    final response = await _dio.get(ApiConstants.adminAnalytics);
    return AnalyticsModel.fromJson(response.data);
  }

  // Verifications

  Future<List<NgoVerificationModel>> getPendingVerifications() async {
    final response = await _dio.get('${ApiConstants.adminVerifications}/pending');
    print('Pending verifications response: ${response.data}');
    final List list = response.data ?? [];
    return list.map((json) => NgoVerificationModel.fromJson(json)).toList();
  }


  Future<NgoVerificationModel> approveNgo(String ngoProfileId) async {
    final response = await _dio.put('${ApiConstants.adminVerifications}/$ngoProfileId/approve');
    return NgoVerificationModel.fromJson(response.data);
  }

  Future<NgoVerificationModel> rejectNgo(String ngoProfileId, String reason) async {
    final response = await _dio.put('${ApiConstants.adminVerifications}/$ngoProfileId/reject', data: {'reason': reason});
    return NgoVerificationModel.fromJson(response.data);
  }

  // Fraud Reports
  Future<List<FraudReportModel>> getPendingFraudReports() async {
    final response = await _dio.get('${ApiConstants.adminReports}/pending');
    print('Pending fraud reports response: ${response.data}');
    final List list = response.data ?? [];
    return list.map((json) => FraudReportModel.fromJson(json)).toList();
  }
  Future<void> dismissReport(String reportId) async {
    await _dio.put('${ApiConstants.adminReports}/$reportId/dismiss');
  }

  Future<void> warnNgo(String reportId) async {
    await _dio.put('${ApiConstants.adminReports}/$reportId/warn');
  }

  Future<void> removeNgo(String reportId) async {
    await _dio.put('${ApiConstants.adminReports}/$reportId/remove');
  }

  // lib/features/admin_dashboard/services/admin_service.dart
// ... other methods remain same

// Add this method to fetch all NGOs (you may need a backend endpoint GET /ngo/all)
// If not available, you can fetch from search with empty query
  Future<List<NgoVerificationModel>> _getAllNgos() async {
    // Assuming GET /ngo/search?q= returns all if q is empty
    final response = await _dio.get('${ApiConstants.ngoSearch}?q=');
    final List list = response.data;
    return list.map((json) => NgoVerificationModel.fromJson(json)).toList();
  }
  Future<List<CampaignImpactModel>> getCampaignsForImpactVerification() async {
    try {
      // Try to get all NGOs – you might need a dedicated admin endpoint
      final response = await _dio.get('${ApiConstants.ngoSearch}?q=');
      final List ngos = response.data ?? [];
      final List<CampaignImpactModel> pendingCampaigns = [];
      for (var ngo in ngos) {
        try {
          final ngoId = ngo['id'];
          final campaignsResponse = await _dio.get('${ApiConstants.campaigns}/ngo/$ngoId');
          final List campaigns = campaignsResponse.data ?? [];
          for (var camp in campaigns) {
            if (camp['impactProofUrl'] != null && camp['impactVerified'] == false) {
              final campaign = CampaignImpactModel.fromJson(camp);
              campaign.ngoName = ngo['name'] ?? 'Unknown';
              pendingCampaigns.add(campaign);
            }
          }
        } catch (e) {
          // Skip NGOs that fail
        }
      }
      return pendingCampaigns;
    } catch (e) {
      print('Error fetching pending impact campaigns: $e');
      return [];
    }
  }

  Future<void> verifyCampaignImpact(String campaignId) async {
    await _dio.put('${ApiConstants.campaigns}/$campaignId/verify-impact');
  }
}