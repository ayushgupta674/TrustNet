// lib/features/explore/providers/explore_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/nog_model.dart';
import '../repository/explore_repository.dart';

final exploreRepositoryProvider = Provider((ref) => ExploreRepository());

// Search results provider (depends on query)
final searchResultsProvider = FutureProvider.family<List<NgoModel>, String>((ref, query) async {
  final repo = ref.read(exploreRepositoryProvider);
  return repo.searchNgos(query);
});

// Nearby results provider (depends on location and radius)
final nearbyNgosProvider = FutureProvider.family<List<NgoModel>, ({double lat, double lng, double radius})>((ref, params) async {
  final repo = ref.read(exploreRepositoryProvider);
  return repo.findNearbyNgos(params.lat, params.lng, params.radius);
});

// Simple state for search text
final searchQueryProvider = StateProvider<String>((ref) => '');

// Loading flag for nearby search
final isNearbyLoadingProvider = StateProvider<bool>((ref) => false);