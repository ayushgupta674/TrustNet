// lib/features/ngo_dashboard/data/ngo_dashboard_repository.dart
import '../models/posts_model.dart';
import '../services/ngo_dashboard_service.dart';
import '../models/ngo_profile_model.dart';
import '../models/campaign_model.dart';
import '../models/volunteer_post_model.dart';

class NgoDashboardRepository {
  final NgoDashboardService _service = NgoDashboardService();

  // Profile
  Future<NgoProfileModel> getMyProfile() => _service.getMyProfile();
  Future<NgoProfileModel> updateProfile(Map<String, dynamic> data) => _service.updateProfile(data);

  // Campaigns
  Future<List<CampaignModel>> getMyCampaigns() => _service.getMyCampaigns();
  Future<CampaignModel> createCampaign(Map<String, dynamic> data) => _service.createCampaign(data);
  Future<CampaignModel> uploadImpactProof(String campaignId, String proofUrl) => _service.uploadImpactProof(campaignId, proofUrl);
  Future<CampaignModel> postOutcome(String campaignId, String outcome) => _service.postOutcome(campaignId, outcome);

  // Posts
  Future<List<PostModel>> getMyPosts() => _service.getMyPosts();
  Future<PostModel> createPost(Map<String, dynamic> data) => _service.createPost(data);

  // Volunteer
  Future<List<VolunteerPostModel>> getMyVolunteerPosts() => _service.getMyVolunteerPosts();
  Future<VolunteerPostModel> createVolunteerPost(Map<String, dynamic> data) => _service.createVolunteerPost(data);
  Future<VolunteerPostModel> acceptVolunteer(String postId, String applicantId) => _service.acceptVolunteer(postId, applicantId);
  Future<VolunteerPostModel> rejectVolunteer(String postId, String applicantId) => _service.rejectVolunteer(postId, applicantId);
}