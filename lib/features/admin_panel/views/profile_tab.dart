// lib/features/admin_dashboard/views/profile_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/storage_manager.dart';
import '../../../core/utils/logout_util.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.wait([
        StorageManager.getUserName(),
        StorageManager.getUserRole(),
        StorageManager.getUserId(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final name = snapshot.data?[0] ?? 'Admin';
        final role = snapshot.data?[1] ?? 'ADMIN';
        final userId = snapshot.data?[2] ?? '';
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 50, child: Text(name[0].toUpperCase(), style: const TextStyle(fontSize: 40))),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(role),
              const SizedBox(height: 8),
              Text('ID: $userId'),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                  onPressed: () => LogoutUtil.logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        );
      },
    );
  }
}