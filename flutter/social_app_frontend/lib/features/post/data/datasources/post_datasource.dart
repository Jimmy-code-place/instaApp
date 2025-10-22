import 'dart:convert';
import 'dart:io';
import 'package:social_app_frontend/core/network/http_client.dart';

class PostDataSource {
  final HttpClient client;

  PostDataSource(this.client);

  Future<List<dynamic>> getPosts(bool isGuest) async {
    final response = await client.get(
      isGuest ? '/posts/guest' : '/posts',
      useAuth: !isGuest,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<void> createPost(String content, File? image) async {
    await client.postMultipart(
      '/posts',
      content.isNotEmpty ? {'content': content} : {},
      filePath: image?.path,
      fileField: 'image',
    );
  }

  Future<void> likePost(int postId) async {
    await client.post('/posts/$postId/like');
  }

  Future<void> commentPost(int postId, String content) async {
    await client.post('/posts/$postId/comments', body: {'content': content});
  }
}
