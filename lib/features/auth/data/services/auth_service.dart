// lib/features/auth/services/auth_service.dart

import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';

class AuthService {
  final DioClient _dioClient = DioClient();


  Future<AuthResponse> register(RegisterRequest request) async {
  try {
  print('Sending: ${request.toJson()}');
  final response = await _dioClient.post(ApiConstants.register, data: request.toJson());
  print('Response: ${response.data}');
  return AuthResponse.fromJson(response.data);
  } catch (e) {
  print('Registration error: $e');
  // Try to extract the actual error message from DioException
  if (e is DioException) {
    print('Full error response: ${e.response?.data}');
    // Try to extract message
    final errorData = e.response?.data;
    if (errorData is Map) {
      print('Error message: ${errorData['message'] ?? errorData['error']}');
    }
  }

  rethrow;
  }
  }


  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dioClient.post(ApiConstants.login, data: request.toJson());
    return AuthResponse.fromJson(response.data);
  }
}