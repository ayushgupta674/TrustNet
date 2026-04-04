// lib/features/donor_profile/data/donor_profile_repository.dart

import '../model/profile_model.dart';
import '../service/donor_profile_service.dart';

class DonorProfileRepository {
  final DonorProfileService _service = DonorProfileService();

  Future<DonorProfileModel> getMyProfile() => _service.getMyProfile();
}