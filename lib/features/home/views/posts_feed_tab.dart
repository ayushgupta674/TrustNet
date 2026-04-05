// lib/features/home/views/home_feed_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../ngo_dashboard/data/models/posts_model.dart';
import '../../ngo_dashboard/widgets/post_card.dart';

final feedProvider = FutureProvider<List<PostModel>>((ref) async {
  final dio = DioClient();
  final response = await dio.get(ApiConstants.feed);
  final List posts = response.data ?? [];
  List<PostModel> result = [];
  for (var postJson in posts) {
    final ngoId = postJson['ngoId'];
    try {
      // Fetch NGO profile to get the name
      final ngoResponse = await dio.get('${ApiConstants.ngoProfile}/$ngoId');
      final ngoName = ngoResponse.data['name'] ?? 'Unknown NGO';
      result.add(PostModel.fromJson(postJson, ngoName: ngoName));
    } catch (e) {
      // Fallback if NGO profile fetch fails
      result.add(PostModel.fromJson(postJson, ngoName: 'Unknown NGO'));
    }
  }
  return result;
});

class HomeFeedTab extends ConsumerWidget {
  const HomeFeedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    return feedAsync.when(
      data: (posts) {
        if (posts.isEmpty) return const Center(child: Text('No posts yet. Follow NGOs to see their updates.'));
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) => PostCard(post: posts[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Failed to load feed: $err')),
    );
  }
}