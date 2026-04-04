// lib/features/donor_profile/services/donor_profile_service.dart
import '../../../../core/network/dio_client.dart';
import '../model/profile_model.dart';


class DonorProfileService {
  final DioClient _dio = DioClient();

  Future<DonorProfileModel> getMyProfile() async {
    final response = await _dio.get('/donor/profile'); // Adjust endpoint if needed
    return DonorProfileModel.fromJson(response.data);
  }
}