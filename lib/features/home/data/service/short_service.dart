// lib/features/shorts/data/services/shorts_service.dart
 // reuse model

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../ngo_dashboard/data/models/ngo_profile_model.dart';
import '../model/shorts_model.dart';

class ShortsService {
  final DioClient _dio = DioClient();
  final Map<String, NgoProfileModel> _ngoCache = {};

  Future<List<ShortModel>> fetchShorts() async {
    // 1. Fetch feed posts
    final feedResponse = await _dio.get(ApiConstants.feed);
    final List posts = feedResponse.data ?? [];

    // 2. For each post, fetch the NGO profile (cached)
    final List<ShortModel> shorts = [];
    for (var post in posts) {
      final ngoId = post['ngoId'];
      NgoProfileModel ngoProfile;
      if (_ngoCache.containsKey(ngoId)) {
        ngoProfile = _ngoCache[ngoId]!;
      } else {
        final profileResponse = await _dio.get('${ApiConstants.ngoProfile}/$ngoId');
        ngoProfile = NgoProfileModel.fromJson(profileResponse.data);
        _ngoCache[ngoId] = ngoProfile;
      }

      // Build ShortModel
      final text = post['text'] as String;
      final lines = text.split('\n');
      final title = lines.first;
      final description = lines.length > 1 ? lines.skip(1).join('\n') : '';

      shorts.add(ShortModel(
        id: post['id'],
        title: title,
        creatorName: ngoProfile.name,
        description: description,
        tag: ngoProfile.cause,
        isFollowing: false, // will be set later if we implement follow check
        ngoId: ngoId,
      ));
    }
    return shorts;
  }
}