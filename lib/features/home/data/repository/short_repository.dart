// lib/features/shorts/data/shorts_repository.dart


import '../model/shorts_model.dart';
import '../service/short_service.dart';

class ShortsRepository {
  final ShortsService _service = ShortsService();

  Future<List<ShortModel>> getShorts() => _service.fetchShorts();
}