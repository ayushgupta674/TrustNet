// lib/features/shorts/widgets/short_page_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/shorts_model.dart';
import '../providers/shorts_provider.dart';


class ShortPageItem extends ConsumerWidget {
  final ShortModel short;

  const ShortPageItem({super.key, required this.short});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followState = ref.watch(shortFollowStateProvider);
    final isFollowing = followState[short.id] ?? short.isFollowing;

    return Container(
      color: Colors.black87, // dark background for video-like feel
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                short.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              // Creator & Follow button
              Row(
                children: [
                  Text(
                    short.creatorName,
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(shortFollowStateProvider.notifier).toggleFollow(short.id, isFollowing);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.grey.shade700 : const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(isFollowing ? 'Following' : 'Follow'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Description
              Text(
                short.description,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const Spacer(),
              // Optional: like/share icons at bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white, size: 32),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white, size: 32),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}