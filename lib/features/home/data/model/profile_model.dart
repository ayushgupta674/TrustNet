// lib/features/donor_profile/models/donor_profile_model.dart
class DonorProfileModel {
  final String id;
  final String userId;
  final String name;
  final List<String> followedNgoIds;
  final List<String> donationIds;
  final List<String> volunteerApplicationIds;

  DonorProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.followedNgoIds,
    required this.donationIds,
    required this.volunteerApplicationIds,
  });

  factory DonorProfileModel.fromJson(Map<String, dynamic> json) => DonorProfileModel(
    id: json['id'],
    userId: json['userId'],
    name: json['name'],
    followedNgoIds: List<String>.from(json['followedNgoIds'] ?? []),
    donationIds: List<String>.from(json['donationIds'] ?? []),
    volunteerApplicationIds: List<String>.from(json['volunteerApplicationIds'] ?? []),
  );
}