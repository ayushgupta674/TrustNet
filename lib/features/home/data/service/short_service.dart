// lib/features/shorts/services/shorts_service.dart
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';

import '../../../ngo_dashboard/data/models/ngo_profile_model.dart';

import '../model/shorts_model.dart';

class ShortsService {
  final DioClient _dio = DioClient();
  final Map<String, NgoProfileModel> _ngoCache = {};

  Future<NgoProfileModel> _getNgoProfile(String ngoId) async {
    if (_ngoCache.containsKey(ngoId)) {
      return _ngoCache[ngoId]!;
    }
    final response = await _dio.get('${ApiConstants.ngoProfile}/$ngoId');
    final profile = NgoProfileModel.fromJson(response.data);
    _ngoCache[ngoId] = profile;
    return profile;
  }

  Future<List<ShortModel>> fetchShorts() async {
    final response = await _dio.get(ApiConstants.feed);
    final List posts = response.data ?? [];
    final List<ShortModel> shorts = [];

    for (var post in posts) {
      // Only include posts that have a videoUrl
      if (post['videoUrl'] != null && post['videoUrl'].toString().isNotEmpty) {
        final ngoId = post['ngoId'];
        final ngoProfile = await _getNgoProfile(ngoId);
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
          ngoId: ngoId,
          videoUrl: post['videoUrl'],
          imageUrl: post['imageUrl'],
          isFollowing: false,
        ));
      }
    }
    return shorts;
  }
}