import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_frontend/core/localization/app_localization.dart';

import 'package:social_app_frontend/core/theme/app_theme.dart';
import 'package:social_app_frontend/features/auth/presentaion/pages/sign_in_page.dart';

import 'package:social_app_frontend/features/auth/presentaion/providers/auth_provider.dart';

import 'package:social_app_frontend/features/post/presentaion/providers/post_provider.dart';
import 'package:social_app_frontend/features/post/presentaion/widgets/post_card.dart';
import 'package:social_app_frontend/features/profile/presentaion/pages/profile_page.dart';
import 'package:social_app_frontend/features/settings/presentaion/pages/settings_page.dart';

class PostsPage extends ConsumerStatefulWidget {
  final bool isGuest;
  const PostsPage({super.key, required this.isGuest});

  @override
  ConsumerState<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends ConsumerState<PostsPage> {
  final TextEditingController contentController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final posts = ref.watch(postsProvider(widget.isGuest));
    final postNotifier = ref.watch(
      postNotifierProvider(widget.isGuest).notifier,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('posts'))),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: AppTheme.gradientDecoration(),
              child: Text(
                l10n.translate('app_title'),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text(l10n.translate('posts')),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text(l10n.translate('profile')),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ),
            ),
            ListTile(
              title: Text(l10n.translate('settings')),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              ),
            ),
            if (!widget.isGuest)
              ListTile(
                title: Text(l10n.translate('logout')),
                onTap: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInPage()),
                    );
                  }
                },
              ),
          ],
        ),
      ),
      body: Container(
        decoration: AppTheme.gradientDecoration(),
        child: posts.when(
          data: (data) => RefreshIndicator(
            onRefresh: () => ref.refresh(postsProvider(widget.isGuest).future),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, index) => PostCard(
                post: data[index],
                onLike: postNotifier.likePost,
                onComment: postNotifier.commentPost,
                isGuest: widget.isGuest,
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(l10n.translate('error'))),
        ),
      ),
      floatingActionButton: widget.isGuest
          ? null
          : FloatingActionButton(
              onPressed: () => _showAddPostDialog(context, postNotifier),
              child: const Icon(Icons.add),
            ),
    );
  }

  void _showAddPostDialog(BuildContext context, PostNotifier notifier) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.translate('add_post')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: l10n.translate('content')),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null && context.mounted) {
                  setState(() => _image = File(picked.path));
                }
              },
              child: Text(l10n.translate('pick_image')),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              await notifier.createPost(contentController.text, _image);
              contentController.clear();
              setState(() => _image = null);
              if (context.mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.translate('add_post')),
          ),
        ],
      ),
    );
  }
}
