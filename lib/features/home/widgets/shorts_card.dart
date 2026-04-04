// lib/features/shorts/widgets/short_page_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/shorts_model.dart';
import '../providers/shorts_provider.dart';
import '../views/ngo_description_screen.dart';

class ShortPageItem extends ConsumerStatefulWidget {
  final ShortModel short;

  const ShortPageItem({super.key, required this.short});

  @override
  ConsumerState<ShortPageItem> createState() => _ShortPageItemState();
}

class _ShortPageItemState extends ConsumerState<ShortPageItem> {
  bool _isExpanded = false;
  bool _isLiked = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _onReport() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Report Content'),
        content: const Text('Are you sure you want to report this short?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your report. We will review it.')),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final followState = ref.watch(shortFollowStateProvider);
    final isFollowing = followState[widget.short.id] ?? widget.short.isFollowing;

    // Determine tag text (fallback to "General")
    final tagText = (widget.short.tag != null && widget.short.tag!.isNotEmpty)
        ? widget.short.tag!
        : 'General';

    return Container(
      color: Colors.black87,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Stack(
                children: [
                  // Main content (bottom-left)
                  Positioned(
                    left: 20,
                    right: 70,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          widget.short.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // NGO name + verified badge + tag (always shown)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => NgoDescriptionScreen(
                                                ngoName: widget.short.creatorName,
                                                ngoDescription: widget.short.description,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          widget.short.creatorName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.verified,
                                        color: Colors.blueAccent,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  // Tag pill - always visible
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tagText,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Follow button
                        ElevatedButton(
                          onPressed: () {
                            ref.read(shortFollowStateProvider.notifier).toggleFollow(widget.short.id, isFollowing);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowing ? Colors.grey.shade700 : const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text(isFollowing ? 'Following' : 'Follow'),
                        ),
                        const SizedBox(height: 20),

                        // Expandable description (scrollable if too long)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight * 0.3,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.short.description,
                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                  maxLines: _isExpanded ? null : 2,
                                  overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                if (widget.short.description.length > 100)
                                  GestureDetector(
                                    onTap: _toggleExpand,
                                    child: Text(
                                      _isExpanded ? 'Read less' : 'Read more',
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right-side action column: Like, Share, Report
                  Positioned(
                    right: 12,
                    bottom: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked ? Colors.red : Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              _isLiked = !_isLiked;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white, size: 32),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Share feature coming soon')),
                            );
                          },
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (value) {
                            if (value == 'report') _onReport();
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'report', child: Text('Report')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}