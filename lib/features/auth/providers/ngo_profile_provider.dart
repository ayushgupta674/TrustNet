// lib/features/auth/providers/ngo_profile_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../ngo_dashboard/data/models/ngo_profile_model.dart';


final ngoProfileRepositoryProvider = Provider((ref) => NgoProfileRepository());

class NgoProfileRepository {
  final DioClient _dio = DioClient();

  Future<NgoProfileModel> getMyProfile() async {
    final response = await _dio.get(ApiConstants.ngoProfile);
    return NgoProfileModel.fromJson(response.data);
  }

  Future<NgoProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.ngoProfile, data: data);
    return NgoProfileModel.fromJson(response.data);
  }

  Future<bool> isProfileComplete() async {
    final profile = await getMyProfile();
    return profile.description != null && profile.description!.isNotEmpty;
  }
}

final ngoProfileProvider = FutureProvider<NgoProfileModel>((ref) async {
  final repo = ref.read(ngoProfileRepositoryProvider);
  return repo.getMyProfile();
});

final isProfileCompleteProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(ngoProfileRepositoryProvider);
  return repo.isProfileComplete();
});