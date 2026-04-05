// lib/features/auth/models/auth_request.dart
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String role; // "NGO" or "USER"
  // NGO-specific fields (optional, used only for NGO)
  // final String? cause;
  // final double? latitude;
  // final double? longitude;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    // this.cause,
    // this.latitude,
    // this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'role': role,
    // if (cause != null) 'cause': cause,
    // if (latitude != null) 'location': [longitude, latitude], // API expects [lng, lat]
  };
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}