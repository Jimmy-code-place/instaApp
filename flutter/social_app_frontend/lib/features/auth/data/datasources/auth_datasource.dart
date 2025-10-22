import 'dart:convert';
import 'package:social_app_frontend/core/network/http_client.dart';

class AuthDataSource {
  final HttpClient client;

  AuthDataSource(this.client);

  Future<String?> register(String name, String email, String password) async {
    final response = await client.post(
      '/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'];
    }
    return null;
  }

  Future<String?> login(String email, String password) async {
    final response = await client.post(
      '/login',
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'];
    }
    return null;
  }

  Future<void> logout() async {
    await client.post('/logout');
  }
}
