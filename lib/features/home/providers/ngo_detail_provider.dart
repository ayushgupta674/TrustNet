// lib/features/ngo_detail/providers/ngo_detail_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ngo_dashboard/data/models/ngo_profile_model.dart';
import '../../ngo_dashboard/data/models/posts_model.dart';
import '../data/repository/ngo_detail_repository.dart';


final ngoDetailRepositoryProvider = Provider((ref) => NgoDetailRepository());

final ngoProfileDetailProvider = FutureProvider.family<NgoProfileModel, String>((ref, ngoId) async {
  final repo = ref.read(ngoDetailRepositoryProvider);
  return repo.getNgoProfile(ngoId);
});

final ngoPostsProvider = FutureProvider.family<List<PostModel>, String>((ref, ngoId) async {
  final repo = ref.read(ngoDetailRepositoryProvider);
  return repo.getNgoPosts(ngoId);
});