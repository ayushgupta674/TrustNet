// lib/features/home/services/post_interaction_service.dart

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/comment_model.dart';

class PostInteractionService {
  final DioClient _dio = DioClient();

  // ------------------------------------------------------------------
  // Like / Unlike
  // ------------------------------------------------------------------
  Future<void> likePost(String postId) async {
    try {
      await _dio.post('${ApiConstants.posts}/$postId/like');
    } catch (e) {
      print('Like error: $e');
      rethrow;
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      await _dio.delete('${ApiConstants.posts}/$postId/like');
    } catch (e) {
      print('Unlike error: $e');
      rethrow;
    }
  }

  Future<bool> isLikedByUser(String postId) async {
    try {
      final response = await _dio.get('${ApiConstants.posts}/$postId/liked');
      return response.data['liked'] ?? false;
    } catch (e) {
      print('Check liked error: $e');
      return false;
    }
  }

  // ------------------------------------------------------------------
  // Comments
  // ------------------------------------------------------------------
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final response = await _dio.get('${ApiConstants.posts}/$postId/comments');
      final List list = response.data ?? [];
      return list.map((json) => CommentModel.fromJson(json)).toList();
    } catch (e) {
      print('Get comments error: $e');
      // Return mock data for development (remove when backend ready)
      return _getMockComments();
    }
  }

  Future<CommentModel> addComment(String postId, String text) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.posts}/$postId/comments',
        data: {'text': text},
      );
      return CommentModel.fromJson(response.data);
    } catch (e) {
      print('Add comment error: $e');
      // Mock successful comment for development
      return CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        userName: 'You',
        text: text,
        createdAt: DateTime.now(),
      );
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _dio.delete('${ApiConstants.comments}/$commentId');
    } catch (e) {
      print('Delete comment error: $e');
      rethrow;
    }
  }

  Future<int> getCommentCount(String postId) async {
    try {
      final response = await _dio.get('${ApiConstants.posts}/$postId/comments/count');
      return response.data['count'] ?? 0;
    } catch (e) {
      print('Comment count error: $e');
      return 0;
    }
  }

  // ------------------------------------------------------------------
  // Mock data for development (remove when backend endpoints are ready)
  // ------------------------------------------------------------------
  List<CommentModel> _getMockComments() {
    return [
      CommentModel(
        id: 'mock1',
        userId: 'user1',
        userName: 'John Doe',
        text: 'This is a great post!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      CommentModel(
        id: 'mock2',
        userId: 'user2',
        userName: 'Jane Smith',
        text: 'Thanks for sharing 👍',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }
}