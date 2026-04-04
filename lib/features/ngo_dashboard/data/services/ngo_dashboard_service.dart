// lib/features/ngo_dashboard/services/ngo_dashboard_service.dart
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';

import '../models/ngo_profile_model.dart';
import '../models/campaign_model.dart';

import '../models/posts_model.dart';
import '../models/volunteer_post_model.dart';

class NgoDashboardService {
  final DioClient _dioClient = DioClient();

  // Profile
  Future<NgoProfileModel> getMyProfile() async {
    final response = await _dioClient.get(ApiConstants.ngoProfile);
    return NgoProfileModel.fromJson(response.data);
  }

  Future<NgoProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _dioClient.put(ApiConstants.ngoProfile, data: data);
    return NgoProfileModel.fromJson(response.data);
  }

  // Campaigns
  Future<List<CampaignModel>> getMyCampaigns() async {
    final ngoId = await _getNgoIdFromProfile();
    final response = await _dioClient.get('${ApiConstants.campaigns}/ngo/$ngoId');
    final List list = response.data;
    return list.map((json) => CampaignModel.fromJson(json)).toList();
  }

  Future<CampaignModel> createCampaign(Map<String, dynamic> data) async {
    final response = await _dioClient.post(ApiConstants.campaigns, data: data);
    return CampaignModel.fromJson(response.data);
  }

  Future<CampaignModel> uploadImpactProof(String campaignId, String proofUrl) async {
    final response = await _dioClient.post('${ApiConstants.campaigns}/$campaignId/proof', data: {'proofUrl': proofUrl});
    return CampaignModel.fromJson(response.data);
  }

  Future<CampaignModel> postOutcome(String campaignId, String outcome) async {
    final response = await _dioClient.post('${ApiConstants.campaigns}/$campaignId/outcome', data: {'outcome': outcome});
    return CampaignModel.fromJson(response.data);
  }

  // Posts
  Future<List<PostModel>> getMyPosts() async {
    final ngoId = await _getNgoIdFromProfile();
    final response = await _dioClient.get('${ApiConstants.posts}/ngo/$ngoId');
    final List list = response.data;
    return list.map((json) => PostModel.fromJson(json)).toList();
  }

  Future<PostModel> createPost(Map<String, dynamic> data) async {
    final response = await _dioClient.post(ApiConstants.posts, data: data);
    return PostModel.fromJson(response.data);
  }

  // Volunteer Posts
  Future<List<VolunteerPostModel>> getMyVolunteerPosts() async {
    final ngoId = await _getNgoIdFromProfile();
    final response = await _dioClient.get('${ApiConstants.volunteerPosts}/ngo/$ngoId');
    final List list = response.data;
    return list.map((json) => VolunteerPostModel.fromJson(json)).toList();
  }

  Future<VolunteerPostModel> createVolunteerPost(Map<String, dynamic> data) async {
    final response = await _dioClient.post(ApiConstants.volunteerPosts, data: data);
    return VolunteerPostModel.fromJson(response.data);
  }

  Future<VolunteerPostModel> acceptVolunteer(String postId, String applicantId) async {
    final response = await _dioClient.put('${ApiConstants.volunteerPosts}/$postId/applications/$applicantId/accept');
    return VolunteerPostModel.fromJson(response.data);
  }

  Future<VolunteerPostModel> rejectVolunteer(String postId, String applicantId) async {
    final response = await _dioClient.put('${ApiConstants.volunteerPosts}/$postId/applications/$applicantId/reject');
    return VolunteerPostModel.fromJson(response.data);
  }

  // Helper to get NGO ID from profile
  Future<String> _getNgoIdFromProfile() async {
    final profile = await getMyProfile();
    return profile.id;
  }
}