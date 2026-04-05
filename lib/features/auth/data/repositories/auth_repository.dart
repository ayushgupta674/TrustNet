// lib/features/auth/data/auth_repository.dart
import '../services/auth_service.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future<AuthResponse> register(RegisterRequest request) => _service.register(request);
  Future<AuthResponse> login(LoginRequest request) => _service.login(request);
}