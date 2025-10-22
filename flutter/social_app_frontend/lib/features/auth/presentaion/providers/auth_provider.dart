import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:social_app_frontend/core/network/http_client.dart';
import 'package:social_app_frontend/core/storage/hive_storage.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../domain/repositories/auth_repository.dart';

final authDataSourceProvider = Provider<AuthDataSource>(
  (ref) => AuthDataSource(ref.read(httpClientProvider)),
);
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(authDataSourceProvider), HiveStorage()),
);
final httpClientProvider = Provider<HttpClient>((ref) => HttpClient());

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(false);

  Future<bool> register(String name, String email, String password) async {
    final success = await repository.register(name, email, password);
    state = success;
    return success;
  }

  Future<bool> login(String email, String password) async {
    final success = await repository.login(email, password);
    state = success;
    return success;
  }

  Future<void> logout() async {
    await repository.logout();
    state = false;
  }
}
