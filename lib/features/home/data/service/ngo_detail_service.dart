// lib/features/ngo_detail/services/ngo_detail_service.dart
// reuse PostModel

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../ngo_dashboard/data/models/ngo_profile_model.dart';
import '../../../ngo_dashboard/data/models/posts_model.dart';

class NgoDetailService {
  final DioClient _dio = DioClient();

  Future<NgoProfileModel> getNgoProfile(String ngoId) async {
    final response = await _dio.get('${ApiConstants.ngoProfile}/$ngoId');
    return NgoProfileModel.fromJson(response.data);
  }

  Future<List<PostModel>> getNgoPosts(String ngoId) async {
    final response = await _dio.get('${ApiConstants.posts}/ngo/$ngoId');
    final List list = response.data;
    return list.map((json) => PostModel.fromJson(json)).toList();
  }
}