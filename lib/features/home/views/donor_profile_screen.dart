// lib/features/donor_profile/views/donor_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/donor_profile_provider.dart';


class DonorProfileScreen extends ConsumerWidget {
  const DonorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(donorProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), backgroundColor: const Color(0xFF7C3AED)),
      body: profileAsync.when(
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF7C3AED).withOpacity(0.2),
                child: Text(profile.name[0].toUpperCase(), style: const TextStyle(fontSize: 40)),
              ),
              const SizedBox(height: 16),
              Text(profile.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Donor', style: TextStyle(color: Colors.grey.shade600)),
              const Divider(height: 32),
              _statCard('NGOs Followed', profile.followedNgoIds.length),
              _statCard('Donations Made', profile.donationIds.length),
              _statCard('Volunteer Applications', profile.volunteerApplicationIds.length),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _statCard(String title, int count) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        trailing: Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}