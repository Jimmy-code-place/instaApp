import 'package:social_app_frontend/core/storage/hive_storage.dart';
import '../../data/datasources/auth_datasource.dart';

abstract class AuthRepository {
  Future<bool> register(String name, String email, String password);
  Future<bool> login(String email, String password);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  final HiveStorage storage;

  AuthRepositoryImpl(this.dataSource, this.storage);

  @override
  Future<bool> register(String name, String email, String password) async {
    final token = await dataSource.register(name, email, password);
    if (token != null) {
      await storage.saveToken(token);
      return true;
    }
    return false;
  }

  @override
  Future<bool> login(String email, String password) async {
    final token = await dataSource.login(email, password);
    if (token != null) {
      await storage.saveToken(token);
      return true;
    }
    return false;
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
    await storage.clearToken();
  }
}
