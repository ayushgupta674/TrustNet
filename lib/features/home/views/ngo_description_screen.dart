// lib/features/ngo_detail/views/ngo_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trust_net/features/payments/views/payment_screen.dart';
import '../../../core/storage/storage_manager.dart';
import '../../ngo_dashboard/data/models/ngo_profile_model.dart';
import '../../ngo_dashboard/widgets/post_card.dart';
import '../providers/ngo_detail_provider.dart';

class NgoDetailScreen extends ConsumerStatefulWidget {
  final String ngoId;

  const NgoDetailScreen({super.key, required this.ngoId});

  @override
  ConsumerState<NgoDetailScreen> createState() => _NgoDetailScreenState();
}

class _NgoDetailScreenState extends ConsumerState<NgoDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false; // temporary – will be fetched from backend later

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _toggleFollow() async {
    // TODO: call backend follow/unfollow endpoint
    setState(() => _isFollowing = !_isFollowing);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isFollowing ? 'Following' : 'Unfollowed')),
    );
  }

  void _donate(NgoProfileModel ngo) {

      print('Donate button tapped for NGO: ${ngo.id}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          ngoId: ngo.id,
          campaignId: '', // optional; can leave empty for general donation
          // you can let user choose amount
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(ngoProfileDetailProvider(widget.ngoId));
    final postsAsync = ref.watch(ngoPostsProvider(widget.ngoId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Details'),
        backgroundColor: const Color(0xFF7C3AED),
      ),
      body: profileAsync.when(
        data: (ngo) {
          return Column(
            children: [
              // Header with name, cause, badge, buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ngo.name,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (ngo.verifiedBadge)
                          const Icon(Icons.verified, color: Colors.blueAccent),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(ngo.cause, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Text(ngo.description),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _toggleFollow,
                          icon: Icon(_isFollowing ? Icons.person_remove : Icons.person_add),
                          label: Text(_isFollowing ? 'Following' : 'Follow'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFollowing ? Colors.grey : const Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => _donate(ngo),
                          icon: const Icon(Icons.money),
                          label: const Text('Donate'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('${ngo.followerIds.length} followers'),
                  ],
                ),
              ),
              // Tabs: Posts and Shorts
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Posts', icon: Icon(Icons.image)),
                  Tab(text: 'Shorts', icon: Icon(Icons.video_library)),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // POSTS TAB – vertical scroll of full post cards
                    postsAsync.when(
                      data: (posts) {
                        if (posts.isEmpty) return const Center(child: Text('No posts yet'));
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) => PostCard(post: posts[index]),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text('Error: $err')),
                    ),
                    // SHORTS TAB – grid of images (or video thumbnails)
                    postsAsync.when(
                      data: (posts) {
                        if (posts.isEmpty) return const Center(child: Text('No shorts yet'));
                        return GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: post.imageUrl != null
                                  ? Image.network(post.imageUrl!, fit: BoxFit.cover)
                                  : Container(color: Colors.grey, child: const Icon(Icons.image)),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text('Error: $err')),
                    ),
                  ],
                )
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}