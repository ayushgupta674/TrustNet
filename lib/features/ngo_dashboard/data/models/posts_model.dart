// lib/features/ngo_dashboard/data/models/posts_model.dart
class PostModel {
  final String id;
  final String ngoId;
  final String ngoName;          // 👈 new field
  final String text;
  final String? imageUrl;
  final String? videoUrl;
  final String? campaignId;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool likedByUser;

  PostModel({
    required this.id,
    required this.ngoId,
    required this.ngoName,
    required this.text,
    this.imageUrl,
    this.videoUrl,
    this.campaignId,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.likedByUser = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json, {String? ngoName}) {
    return PostModel(
      id: json['id'] as String,
      ngoId: json['ngoId'] as String,
      ngoName: ngoName ?? json['ngoName'] ?? 'Unknown NGO',
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      campaignId: json['campaignId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      likedByUser: json['likedByUser'] ?? false,
    );
  }
}