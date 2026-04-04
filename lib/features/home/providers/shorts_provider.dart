// lib/features/shorts/providers/shorts_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/shorts_model.dart';
import '../data/repository/short_repository.dart';

final shortsRepositoryProvider = Provider((ref) => ShortsRepository());

final shortsProvider = FutureProvider<List<ShortModel>>((ref) async {
  final repo = ref.read(shortsRepositoryProvider);
  return repo.getShorts();
});

// Mutable state for follow/unfollow
final shortFollowStateProvider = StateNotifierProvider<ShortFollowNotifier, Map<String, bool>>((ref) {
  return ShortFollowNotifier();
});

class ShortFollowNotifier extends StateNotifier<Map<String, bool>> {
  ShortFollowNotifier() : super({});

  void toggleFollow(String shortId, bool currentValue) {
    state = {...state, shortId: !currentValue};
  }
}

// Bottom navigation tab index
final bottomTabIndexProvider = StateProvider<int>((ref) => 0);