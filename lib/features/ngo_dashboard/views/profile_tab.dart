import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/logout_util.dart';
import '../providers/ngo_dashboard_providers.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(ngoProfileProvider);

    return profileAsync.when(
      data: (profile) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF7C3AED).withOpacity(0.2),
              child: Text(
                profile.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (profile.verifiedBadge)
                  const Icon(Icons.verified, color: Colors.blueAccent),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              profile.cause,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text('Status: ${profile.verificationStatus}'),
              backgroundColor: profile.verificationStatus == 'VERIFIED'
                  ? Colors.green.shade100
                  : profile.verificationStatus == 'PENDING'
                  ? Colors.orange.shade100
                  : Colors.red.shade100,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _statRow(
                      Icons.people,
                      'Followers',
                      profile.followerIds.length,
                    ),
                    const Divider(),
                    _statRow(
                      Icons.campaign,
                      'Campaigns',
                      // We'll need a separate call or pass from outside. For now use 0.
                      0,
                    ),
                    const Divider(),
                    _statRow(
                      Icons.post_add,
                      'Posts',
                      0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (profile.location.isNotEmpty)
                      Text(
                        'Lat: ${profile.location[1]}, Lng: ${profile.location[0]}',
                      )
                    else
                      const Text('Not provided'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => LogoutUtil.logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],

        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _statRow(IconData icon, String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF7C3AED)),
          const SizedBox(width: 16),
          Text('$label:', style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            '$value',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}