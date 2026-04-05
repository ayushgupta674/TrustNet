// lib/features/home/data/post_interaction_repository.dart
import '../services/post_interaction_service.dart';
import '../models/comment_model.dart';

class PostInteractionRepository {
  final PostInteractionService _service = PostInteractionService();

  Future<void> likePost(String postId) => _service.likePost(postId);
  Future<void> unlikePost(String postId) => _service.unlikePost(postId);
  Future<bool> isLikedByUser(String postId) => _service.isLikedByUser(postId);
  Future<List<CommentModel>> getComments(String postId) => _service.getComments(postId);
  Future<CommentModel> addComment(String postId, String text) => _service.addComment(postId, text);
  Future<void> deleteComment(String commentId) => _service.deleteComment(commentId);
  Future<int> getCommentCount(String postId) => _service.getCommentCount(postId);
}