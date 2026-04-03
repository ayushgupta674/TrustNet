// lib/features/shorts/services/shorts_service.dart


import '../model/shorts_model.dart';

class ShortsService {
  Future<List<ShortModel>> fetchShorts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ShortModel(id: '1', title: '🌱 Green Earth Initiative', creatorName: 'EcoWarriors', description: 'Join us to plant 1000 trees!'),
      ShortModel(id: '2', title: '💧 Save Water Challenge', creatorName: 'WaterAid', description: 'Learn simple tips to conserve water.'),
      ShortModel(id: '3', title: '📢 Volunteer Call', creatorName: 'HelpForce', description: 'We need volunteers for a health camp.'),
      ShortModel(id: '4', title: '♻️ Recycling Drive', creatorName: 'CleanCity', description: 'Bring your e-waste for recycling.'),
    ];
  }
}