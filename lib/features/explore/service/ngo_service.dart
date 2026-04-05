// lib/features/explore/services/explore_service.dart
import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';

import '../model/nog_model.dart';

class ExploreService {
  final DioClient _dio = DioClient();

  Future<List<NgoModel>> searchNgos(String query) async {
    try {
      print('🔍 Searching for: $query');
      final response = await _dio.get(
        ApiConstants.ngoSearch,
        queryParams: {'q': query},
      );
      print('✅ Search response status: ${response.statusCode}');
      print('📦 Search data: ${response.data}');
      final List data = response.data ?? [];
      return data.map((json) => NgoModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Search error: $e');
      if (e is DioException) {
        print('Response: ${e.response?.data}');
      }
      return [];
    }
  }
  Future<List<NgoModel>> findNearbyNgos(double lat, double lng, double radiusKm) async {
    try {
      final response = await _dio.get(
        ApiConstants.ngoNearby,
        queryParams: {
          'longitude': lng,   // note: longitude first (as per backend)
          'latitude': lat,
          'radius': radiusKm,
        },
      );
      final List data = response.data ?? [];
      return data.map((json) => NgoModel.fromJson(json)).toList();
    } catch (e) {
      print('Nearby error: $e');
      return [];
    }
  }
}