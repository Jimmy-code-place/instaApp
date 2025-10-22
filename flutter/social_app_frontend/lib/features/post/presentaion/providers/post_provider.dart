import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:social_app_frontend/features/auth/presentaion/providers/auth_provider.dart';
import '../../data/datasources/post_datasource.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

final postDataSourceProvider = Provider<PostDataSource>(
  (ref) => PostDataSource(ref.read(httpClientProvider)),
); /////
final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepositoryImpl(ref.read(postDataSourceProvider)),
);

final postsProvider = FutureProvider.family<List<Post>, bool>((
  ref,
  isGuest,
) async {
  return ref.read(postRepositoryProvider).getPosts(isGuest);
});

final postNotifierProvider =
    StateNotifierProvider.family<PostNotifier, AsyncValue<List<Post>>, bool>((
      ref,
      isGuest,
    ) {
      return PostNotifier(ref.read(postRepositoryProvider), isGuest);
    });

class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final PostRepository repository;
  final bool isGuest;

  PostNotifier(this.repository, this.isGuest)
    : super(const AsyncValue.loading()) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    state = const AsyncValue.loading();
    try {
      final posts = await repository.getPosts(isGuest);
      state = AsyncValue.data(posts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createPost(String content, File? image) async {
    if (!isGuest) {
      await repository.createPost(content, image);
      await fetchPosts();
    }
  }

  Future<void> likePost(int postId) async {
    if (!isGuest) {
      await repository.likePost(postId);
      await fetchPosts();
    }
  }

  Future<void> commentPost(int postId, String content) async {
    if (!isGuest) {
      await repository.commentPost(postId, content);
      await fetchPosts();
    }
  }
}
