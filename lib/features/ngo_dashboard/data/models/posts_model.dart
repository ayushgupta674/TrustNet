// lib/features/ngo_dashboard/models/post_model.dart
class PostModel {
  final String id;
  final String ngoId;
  final String text;
  final String? imageUrl;
  final String? videoUrl;
  final String? campaignId;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.ngoId,
    required this.text,
    this.imageUrl,
    this.videoUrl,
    this.campaignId,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'],
    ngoId: json['ngoId'],
    text: json['text'],
    imageUrl: json['imageUrl'],
    videoUrl: json['videoUrl'],
    campaignId: json['campaignId'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}