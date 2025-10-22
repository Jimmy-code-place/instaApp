import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:social_app_frontend/core/constants/api_constant.dart';

class HttpClient {
  Future<String?> _getToken() async {
    final box = Hive.box('auth');
    return box.get('token');
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    return token != null
        ? {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}
        : {'Content-Type': 'application/json'};
  }

  Future<http.Response> get(String endpoint, {bool useAuth = true}) async {
    final headers = useAuth
        ? await _authHeaders()
        : {'Content-Type': 'application/json'};
    return http.get(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: headers,
    );
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool useAuth = true,
  }) async {
    final headers = useAuth
        ? await _authHeaders()
        : {'Content-Type': 'application/json'};
    return http.post(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.StreamedResponse> postMultipart(
    String endpoint,
    Map<String, String> fields, {
    String? filePath,
    String? fileField,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
    );
    request.headers.addAll(await _authHeaders());
    request.fields.addAll(fields);
    if (filePath != null && fileField != null) {
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
    }
    return request.send();
  }
}
