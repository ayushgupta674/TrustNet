// lib/features/donor_profile/providers/donor_profile_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/profile_model.dart';
import '../data/repository/donor_profile_repository.dart';


final donorProfileRepositoryProvider = Provider((ref) => DonorProfileRepository());

final donorProfileProvider = FutureProvider<DonorProfileModel>((ref) async {
  final repo = ref.read(donorProfileRepositoryProvider);
  return repo.getMyProfile();
});