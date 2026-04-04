// lib/features/ngo_dashboard/models/volunteer_post_model.dart
class VolunteerPostModel {
  final String id;
  final String ngoId;
  final String skillNeeded;
  final String description;
  final DateTime date;
  final List<VolunteerApplication> applications;

  VolunteerPostModel({
    required this.id,
    required this.ngoId,
    required this.skillNeeded,
    required this.description,
    required this.date,
    required this.applications,
  });

  factory VolunteerPostModel.fromJson(Map<String, dynamic> json) => VolunteerPostModel(
    id: json['id'],
    ngoId: json['ngoId'],
    skillNeeded: json['skillNeeded'],
    description: json['description'],
    date: DateTime.parse(json['date']),
    applications: (json['applications'] as List?)
        ?.map((a) => VolunteerApplication.fromJson(a))
        .toList() ?? [],
  );
}

class VolunteerApplication {
  final String userId;
  final String status; // PENDING, ACCEPTED, REJECTED
  final DateTime appliedAt;

  VolunteerApplication({required this.userId, required this.status, required this.appliedAt});

  factory VolunteerApplication.fromJson(Map<String, dynamic> json) => VolunteerApplication(
    userId: json['userId'],
    status: json['status'],
    appliedAt: DateTime.parse(json['appliedAt']),
  );
}