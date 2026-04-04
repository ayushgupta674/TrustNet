// lib/features/home/widgets/post_card.dart
import 'package:flutter/material.dart';
import '../../ngo_dashboard/data/models/posts_model.dart';


class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.imageUrl != null)
            Image.network(post.imageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(post.text),
          ),
        ],
      ),
    );
  }
}