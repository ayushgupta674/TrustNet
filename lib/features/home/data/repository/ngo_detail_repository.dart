// lib/features/ngo_detail/data/ngo_detail_repository.dart


import '../../../ngo_dashboard/data/models/ngo_profile_model.dart';
import '../../../ngo_dashboard/data/models/posts_model.dart';
import '../service/ngo_detail_service.dart';

class NgoDetailRepository {
  final NgoDetailService _service = NgoDetailService();

  Future<NgoProfileModel> getNgoProfile(String ngoId) => _service.getNgoProfile(ngoId);
  Future<List<PostModel>> getNgoPosts(String ngoId) => _service.getNgoPosts(ngoId);
}