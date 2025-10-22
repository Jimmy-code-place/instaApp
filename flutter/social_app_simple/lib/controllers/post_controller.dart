import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:social_app_simple/models/auth_model.dart';
import '../models/post_model.dart';
import 'auth_controller.dart'; // Import auth controller

final authControllerProvider = StateNotifierProvider<AuthController, AuthModel>(
  (ref) => AuthController(),
);

final postControllerProvider =
    StateNotifierProvider.family<
      PostController,
      AsyncValue<List<PostModel>>,
      bool
    >((ref, isGuest) => PostController(ref, isGuest));

class PostController extends StateNotifier<AsyncValue<List<PostModel>>> {
  final Ref ref;
  final bool isGuest;
  final String baseUrl = 'http://127.0.0.1:8000/api';

  PostController(this.ref, this.isGuest) : super(const AsyncValue.loading()) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      state = const AsyncValue.loading();

      final uri = isGuest
          ? Uri.parse('$baseUrl/posts/guest')
          : Uri.parse('$baseUrl/posts');

      // Fix: Explicitly type the headers as Map<String, String>
      Map<String, String> headers = {};
      if (!isGuest) {
        final authState = ref.read(authControllerProvider);
        if (authState.token != null) {
          headers = {'Authorization': 'Bearer ${authState.token}'};
        }
      }

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final posts = data.map((json) => PostModel.fromJson(json)).toList();
        state = AsyncValue.data(posts);
      } else {
        state = AsyncValue.error(
          Exception('Failed to load posts'),
          StackTrace.current,
        );
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createPost(String content, File? image) async {
    if (isGuest) return;
    try {
      final authState = ref.read(authControllerProvider);
      if (authState.token == null) return;

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'));
      request.headers['Authorization'] = 'Bearer ${authState.token}';

      if (content.isNotEmpty) request.fields['content'] = content;
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        await fetchPosts();
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> likePost(int postId) async {
    if (isGuest) return;
    try {
      final authState = ref.read(authControllerProvider);
      if (authState.token == null) return;

      final headers = <String, String>{
        'Authorization': 'Bearer ${authState.token}',
      };

      await http.post(
        Uri.parse('$baseUrl/posts/$postId/like'),
        headers: headers,
      );
      await fetchPosts();
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> commentPost(int postId, String content) async {
    if (isGuest) return;
    try {
      final authState = ref.read(authControllerProvider);
      if (authState.token == null) return;

      final headers = <String, String>{
        'Authorization': 'Bearer ${authState.token}',
        'Content-Type': 'application/json',
      };

      await http.post(
        Uri.parse('$baseUrl/posts/$postId/comments'),
        headers: headers,
        body: jsonEncode({'content': content}),
      );
      await fetchPosts();
    } catch (e) {
      // Handle error silently
    }
  }
}
