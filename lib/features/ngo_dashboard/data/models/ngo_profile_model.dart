// lib/features/ngo_dashboard/models/ngo_profile_model.dart
class NgoProfileModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String cause;
  final String? registrationDocumentUrl;
  final String verificationStatus; // PENDING, VERIFIED, REJECTED
  final bool verifiedBadge;
  final String? rejectionReason;
  final List<String> followerIds;
  final List<double> location; // [longitude, latitude]

  NgoProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.cause,
    this.registrationDocumentUrl,
    required this.verificationStatus,
    required this.verifiedBadge,
    this.rejectionReason,
    required this.followerIds,
    required this.location,
  });

  factory NgoProfileModel.fromJson(Map<String, dynamic> json) => NgoProfileModel(
    id: json['id'],
    userId: json['userId'],
    name: json['name'],
    description: json['description'],
    cause: json['cause'],
    registrationDocumentUrl: json['registrationDocumentUrl'],
    verificationStatus: json['verificationStatus'],
    verifiedBadge: json['verifiedBadge'] ?? false,
    rejectionReason: json['rejectionReason'],
    followerIds: List<String>.from(json['followerIds'] ?? []),
    location: List<double>.from(json['location'] ?? []),
  );
}