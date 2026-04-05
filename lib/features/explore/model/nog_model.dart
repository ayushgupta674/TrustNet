class NgoModel {
  final String id;
  final String name;
  final String description;
  final String cause;      // matches 'cause' field
  final double? distance;  // only present in nearby results
  final double latitude;   // extracted from location[1]
  final double longitude;  // extracted from location[0]
  final bool isVerified;   // from verifiedBadge
  final String imageUrl;   // optional, not in schema yet

  NgoModel({ required this.id, required this.name, required this.description, required this.cause, this.distance, required this.latitude, required this.longitude, required this.isVerified, required this.imageUrl});
factory NgoModel.fromJson(Map<String, dynamic> json, {double? distance}) {
final location = json['location'] as List? ?? [0.0, 0.0];
return NgoModel(
id: json['id'],
name: json['name'],
description: json['description'] ?? '',
cause: json['cause'] ?? '',
distance: distance ?? (json['distance'] as num?)?.toDouble(),
latitude: location.length > 1 ? location[1] : 0.0,
longitude: location.isNotEmpty ? location[0] : 0.0,
isVerified: json['verifiedBadge'] ?? false,
imageUrl: json['imageUrl'] ?? '',
);
}
}