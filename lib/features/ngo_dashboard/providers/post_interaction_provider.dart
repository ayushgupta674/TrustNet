// lib/features/home/providers/post_interaction_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/comment_model.dart';

import '../data/repositories/post_interaction_repository.dart';


final postInteractionRepositoryProvider = Provider((ref) => PostInteractionRepository());

// Like / Unlike
final likePostProvider = FutureProvider.family<void, String>((ref, postId) async {
  final repo = ref.read(postInteractionRepositoryProvider);
  await repo.likePost(postId);
});

final unlikePostProvider = FutureProvider.family<void, String>((ref, postId) async {
  final repo = ref.read(postInteractionRepositoryProvider);
  await repo.unlikePost(postId);
});

// Comments
final commentsProvider = FutureProvider.family<List<CommentModel>, String>((ref, postId) async {
  final repo = ref.read(postInteractionRepositoryProvider);
  return repo.getComments(postId);
});

final addCommentProvider = FutureProvider.family<CommentModel, ({String postId, String text})>((ref, params) async {
  final repo = ref.read(postInteractionRepositoryProvider);
  return repo.addComment(params.postId, params.text);
});

final deleteCommentProvider = FutureProvider.family<void, String>((ref, commentId) async {
  final repo = ref.read(postInteractionRepositoryProvider);
  await repo.deleteComment(commentId);
});

final commentCountProvider = FutureProvider.family<int, String>((ref, postId) async {
  final repo = ref.read(postInteractionRepositoryProvider);
  return repo.getCommentCount(postId);
});