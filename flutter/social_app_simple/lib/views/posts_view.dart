import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_simple/views/sign_in_view.dart';
import '../controllers/auth_controller.dart';
import '../controllers/post_controller.dart' hide authControllerProvider;
import 'widgets/post_card.dart';
import 'profile_view.dart';
import 'settings_view.dart';

class PostsView extends ConsumerWidget {
  final bool isGuest;

  const PostsView({super.key, required this.isGuest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postControllerProvider(isGuest));
    final postController = ref.read(postControllerProvider(isGuest).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Posts'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileView()),
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsView()),
              ),
            ),
            if (!isGuest)
              ListTile(
                title: const Text('Logout'),
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInView()),
                  );
                },
              ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: postsAsync.when(
          data: (posts) => ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                post: post,
                onLike: (id) => postController.likePost(id),
                onComment: (id, content) =>
                    postController.commentPost(id, content),
                isGuest: isGuest,
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
      floatingActionButton: isGuest
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final contentController = TextEditingController();
                File? image;
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Create Post'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: contentController,
                          decoration: const InputDecoration(
                            labelText: 'Content',
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final picked = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (picked != null) {
                              image = File(picked.path);
                            }
                          },
                          child: const Text('Pick Image'),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          await postController.createPost(
                            contentController.text,
                            image,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Post'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
