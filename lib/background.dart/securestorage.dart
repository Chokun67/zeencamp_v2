import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> read(String key) async {
    var str = await storage.read(key: key);
    return str;
  }

  Future<void> write(String key, String value) async {
    return await storage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    return await storage.delete(key: key);
  }

  Future<Map<String, String>> readAll() async {
    return await storage.readAll();
  }

  Future<void> deleteAll() async {
    return await storage.deleteAll();
  }
}