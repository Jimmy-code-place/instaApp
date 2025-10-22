import 'dart:io';

import 'package:social_app_frontend/features/post/data/datasources/post_datasource.dart';

import '../entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts(bool isGuest);
  Future<void> createPost(String content, File? image);
  Future<void> likePost(int postId);
  Future<void> commentPost(int postId, String content);
}

class PostRepositoryImpl implements PostRepository {
  final PostDataSource dataSource;

  PostRepositoryImpl(this.dataSource);

  @override
  Future<List<Post>> getPosts(bool isGuest) async {
    final data = await dataSource.getPosts(isGuest);
    return data
        .map(
          (json) => Post(
            id: json['id'],
            userName: json['user']['name'],
            content: json['content'],
            imageUrl: json['image_url'],
            likes: List<Map<String, dynamic>>.from(json['likes']),
            comments: List<Map<String, dynamic>>.from(json['comments']),
          ),
        )
        .toList();
  }

  @override
  Future<void> createPost(String content, File? image) async {
    await dataSource.createPost(content, image);
  }

  @override
  Future<void> likePost(int postId) async {
    await dataSource.likePost(postId);
  }

  @override
  Future<void> commentPost(int postId, String content) async {
    await dataSource.commentPost(postId, content);
  }
}
