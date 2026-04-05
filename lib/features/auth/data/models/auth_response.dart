// lib/features/auth/models/auth_response.dart
class AuthResponse {
  final String token;
  final String userId;
  final String name;
  final String role;

  AuthResponse({
    required this.token,
    required this.userId,
    required this.name,
    required this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    token: json['token'],
    userId: json['userId'],
    name: json['name'],
    role: json['role'],
  );
}