import 'package:hive/hive.dart';

class HiveStorage {
  static const String boxName = 'auth';

  Future<void> saveToken(String token) async {
    final box = Hive.box(boxName);
    await box.put('token', token);
  }

  Future<String?> getToken() async {
    final box = Hive.box(boxName);
    return box.get('token');
  }

  Future<void> clearToken() async {
    final box = Hive.box(boxName);
    await box.delete('token');
  }
}
