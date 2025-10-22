import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import '../models/auth_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthModel>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthModel> {
  AuthController() : super(AuthModel(token: null));

  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<bool> login(String email, String password) async {
    try {
      final headers = <String, String>{'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        state = AuthModel(token: data['access_token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final headers = <String, String>{'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        state = AuthModel(token: data['access_token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      if (state.token != null) {
        final headers = <String, String>{
          'Authorization': 'Bearer ${state.token}',
        };
        await http.post(Uri.parse('$baseUrl/logout'), headers: headers);
      }
      state = AuthModel(token: null);
    } catch (e) {
      // Handle error silently
      state = AuthModel(token: null);
    }
  }

  String? get token => state.token;
}
