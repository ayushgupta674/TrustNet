// lib/features/home/views/home_feed_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../ngo_dashboard/data/models/posts_model.dart';
import '../../ngo_dashboard/widgets/post_card.dart';

final feedProvider = FutureProvider<List<PostModel>>((ref) async {
  final dio = DioClient();
  try {
    final response = await dio.get(ApiConstants.feed);
    print('Feed response status: ${response.statusCode}');
    print('Feed data: ${response.data}');
    final List list = response.data ?? [];
    return list.map((json) => PostModel.fromJson(json)).toList();
  } catch (e) {
    print('Feed error: $e');
    if (e is DioException) {
      print('Response data: ${e.response?.data}');
    }
    return []; // Return empty list instead of throwing
  }
});

class HomeFeedTab extends ConsumerWidget {
  const HomeFeedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    return feedAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(
            child: Text('No posts yet. Follow NGOs to see their updates.'),
          );
        }
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) => PostCard(post: posts[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Text('Failed to load feed: ${err.toString()}'),
      ),
    );
  }
}