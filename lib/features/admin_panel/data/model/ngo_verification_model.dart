// lib/features/admin_dashboard/model/ngo_verification_model.dart
class NgoVerificationModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String cause;
  final String registrationDocumentUrl;
  final String verificationStatus;
  final bool verifiedBadge;
  final String? rejectionReason;
  final List<String> followerIds;
  final List<double> location;

  NgoVerificationModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.cause,
    required this.registrationDocumentUrl,
    required this.verificationStatus,
    required this.verifiedBadge,
    this.rejectionReason,
    required this.followerIds,
    required this.location,
  });

  factory NgoVerificationModel.fromJson(Map<String, dynamic> json) {
    // Provide safe defaults for every field
    return NgoVerificationModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      description: json['description']?.toString() ?? '',
      cause: json['cause']?.toString() ?? '',
      registrationDocumentUrl: json['registrationDocumentUrl']?.toString() ?? '',
      verificationStatus: json['verificationStatus']?.toString() ?? 'PENDING',
      verifiedBadge: json['verifiedBadge'] == true,
      rejectionReason: json['rejectionReason']?.toString(),
      followerIds: (json['followerIds'] as List?)?.map((e) => e.toString()).toList() ?? [],
      location: (json['location'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? [],
    );
  }
}