// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/storage_manager.dart';

class DioClient {
  late Dio _dio;
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
    _addInterceptors();
  }

  void _addInterceptors() {
    // Log interceptor to see all requests/responses
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageManager.getToken();
        final userId = await StorageManager.getUserId();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        if (userId != null) {
          options.headers['X-User-Id'] = userId;
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error is DioException) {
          print('=== DIO ERROR ===');
          print('Message: ${error.message}');
          print('Response data: ${error.response?.data}');
          print('Status code: ${error.response?.statusCode}');
        }
        return handler.next(error);
      },
    ));
  }
  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}