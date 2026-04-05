// lib/features/home/widgets/post_card.dart
import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/date_utils.dart';
import '../../explore/views/comment_bottom_sheet.dart';
import '../data/models/posts_model.dart';
import '../providers/post_interaction_provider.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  late bool _isLiked;
  late int _likeCount;
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.likedByUser;
    _likeCount = widget.post.likeCount;
    _commentCount = widget.post.commentCount;
  }

  Future<void> _toggleLike() async {
    final previousLiked = _isLiked;
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    try {
      if (_isLiked) {
        await ref.read(likePostProvider(widget.post.id).future);
      } else {
        await ref.read(unlikePostProvider(widget.post.id).future);
      }
    } catch (e) {
      setState(() {
        _isLiked = previousLiked;
        _likeCount += _isLiked ? 1 : -1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update like')),
      );
    }
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => CommentBottomSheet(postId: widget.post.id),
    ).then((_) {
      ref.invalidate(commentsProvider(widget.post.id));
      ref.read(commentsProvider(widget.post.id).future).then((comments) {
        if (mounted) setState(() => _commentCount = comments.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.post.ngoName.isNotEmpty ? widget.post.ngoName : 'NGO';
    final avatarLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF7C3AED),
                    radius: 20,
                    child: Text(avatarLetter, style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          DateUtils.timeAgo(widget.post.createdAt),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.post.text, style: const TextStyle(fontSize: 16)),
              if (widget.post.imageUrl != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.post.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _actionButton(
                    icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                    label: '$_likeCount',
                    onTap: _toggleLike,
                    color: _isLiked ? Colors.red : null,
                  ),
                  const SizedBox(width: 24),
                  _actionButton(
                    icon: Icons.comment_outlined,
                    label: '$_commentCount',
                    onTap: _openComments,
                  ),
                  const SizedBox(width: 24),
                  _actionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {}, // implement share if needed
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color ?? Colors.grey.shade700, fontSize: 14)),
        ],
      ),
    );
  }
}