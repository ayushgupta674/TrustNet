// lib/features/ngo_dashboard/providers/ngo_dashboard_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/campaign_model.dart';
import '../data/models/ngo_profile_model.dart';
import '../data/models/posts_model.dart';
import '../data/models/volunteer_post_model.dart';
import '../data/repositories/ngo_dashboard_repository.dart';

final ngoDashboardRepositoryProvider = Provider((ref) => NgoDashboardRepository());

// Profile provider
final ngoProfileProvider = FutureProvider<NgoProfileModel>((ref) async {
  final repo = ref.read(ngoDashboardRepositoryProvider);
  return repo.getMyProfile();
});

// Campaigns provider
final ngoCampaignsProvider = FutureProvider<List<CampaignModel>>((ref) async {
  final repo = ref.read(ngoDashboardRepositoryProvider);
  return repo.getMyCampaigns();
});

// Posts provider
final ngoPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  final repo = ref.read(ngoDashboardRepositoryProvider);
  return repo.getMyPosts();
});

// Volunteer posts provider
final ngoVolunteerPostsProvider = FutureProvider<List<VolunteerPostModel>>((ref) async {
  final repo = ref.read(ngoDashboardRepositoryProvider);
  return repo.getMyVolunteerPosts();
});

// Creation providers (used in CreateTab)
final createPostProvider = FutureProvider.family<PostModel, Map<String, dynamic>>((ref, data) async {
  final repo = ref.read(ngoDashboardRepositoryProvider);
  return repo.createPost(data);
});

final createCampaignProvider = FutureProvider.family<CampaignModel, Map<String, dynamic>>((ref, data) async {
  final repo = ref.read(ngoDashboardRepositoryProvider);
  return repo.createCampaign(data);
});

final createVolunteerPostProvider = FutureProvider.family<VolunteerPostModel, Map<String, dynamic>>((ref, data) async {
  final repo = ref.read(ngoDashboardRepositoryProvider);
  return repo.createVolunteerPost(data);
});

// Bottom navigation index
final ngoDashboardTabIndexProvider = StateProvider<int>((ref) => 0);