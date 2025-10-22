import 'package:flutter/material.dart';
import 'package:social_app_frontend/core/localization/app_localization.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
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
    final l10n = AppLocalizations.of(context);
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
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
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
                  color: post.likes.any((like) => like['user_id'] == 1)
                      ? Colors.red
                      : null, // Simplified check
                  onPressed: isGuest ? null : () => onLike(post.id),
                ),
                Text('${post.likes.length}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: post.comments
                  .map(
                    (comment) => ListTile(
                      title: Text(comment['user']['name']),
                      subtitle: Text(comment['content']),
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
                      decoration: InputDecoration(
                        labelText: l10n.translate('comment'),
                      ),
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
