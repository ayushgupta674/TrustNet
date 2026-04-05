// lib/features/explore/data/explore_repository.dart
import '../model/nog_model.dart';
import '../service/ngo_service.dart';


class ExploreRepository {
  final ExploreService _service = ExploreService();

  Future<List<NgoModel>> searchNgos(String query) {
    return _service.searchNgos(query);
  }

  Future<List<NgoModel>> findNearbyNgos(double lat, double lng, double radiusKm) {
    return _service.findNearbyNgos(lat, lng, radiusKm);
  }
}