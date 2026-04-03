// lib/features/shorts/models/short_model.dart
class ShortModel {
  final String id;
  final String title;
  final String creatorName;
  final String description;
  final bool isFollowing;

  ShortModel({
    required this.id,
    required this.title,
    required this.creatorName,
    required this.description,
    this.isFollowing = false,
  });

  ShortModel copyWith({bool? isFollowing}) {
    return ShortModel(
      id: id,
      title: title,
      creatorName: creatorName,
      description: description,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}