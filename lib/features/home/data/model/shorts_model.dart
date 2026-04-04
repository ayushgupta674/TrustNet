// lib/features/shorts/data/model/shorts_model.dart
class ShortModel {
  final String id;
  final String title;
  final String creatorName;
  final String description;
  final String? tag;
  final bool isFollowing;
  final String ngoId; // add this field

  ShortModel({
    required this.id,
    required this.title,
    required this.creatorName,
    required this.description,
    this.tag,
    this.isFollowing = false,
    required this.ngoId, // required
  });
}