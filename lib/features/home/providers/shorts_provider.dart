// lib/features/shorts/providers/shorts_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/shorts_model.dart';
import '../data/repository/short_repository.dart';

// Repository provider
final shortsRepositoryProvider = Provider((ref) => ShortsRepository());

// Shorts feed provider
final shortsProvider = FutureProvider<List<ShortModel>>((ref) async {
  final repo = ref.read(shortsRepositoryProvider);
  return repo.getShorts();
});

// Follow state management
final shortFollowStateProvider = StateNotifierProvider<ShortFollowNotifier, Map<String, bool>>((ref) {
  return ShortFollowNotifier();
});

class ShortFollowNotifier extends StateNotifier<Map<String, bool>> {
  ShortFollowNotifier() : super({});

  void toggleFollow(String shortId) {
    final current = state[shortId] ?? false;
    state = {...state, shortId: !current};
  }
}

// Bottom navigation tab index (0 = Home, 1 = Shorts, 2 = Explore, 3 = Profile)
final bottomTabIndexProvider = StateProvider<int>((ref) => 0);