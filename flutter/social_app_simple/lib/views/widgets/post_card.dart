import 'package:flutter/material.dart';

import 'package:social_app_simple/models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final Function(int) onLike;
  final Function(int, String) onComment;
  final bool isGuest;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              post.userName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: post.content != null ? Text(post.content!) : null,
          ),
          if (post.imageUrl != null)
            Image.network(
              post.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Image load error for ${post.imageUrl}: $error');
                return const Center(child: Icon(Icons.broken_image, size: 100));
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),

                  onPressed: isGuest ? null : () => onLike(post.id),
                ),
                Text('${post.likeCount}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: post.comments
                  .map(
                    (comment) => ListTile(
                      title: Text(comment.userName),
                      subtitle: Text(comment.content),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (!isGuest)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(labelText: 'comment'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        onComment(post.id, commentController.text);
                        commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
