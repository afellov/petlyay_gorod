import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PbClient {
  static late final PocketBase instance;
  static const baseUrl = String.fromEnvironment(
    'POCKETBASE_URL',
    defaultValue: 'http://127.0.0.1:8090',
  );
  static const _authKey = 'pb_auth';
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();
    var initialAuth = await _secureStorage.read(key: _authKey);
    if (initialAuth == null) {
      initialAuth = preferences.getString(_authKey);
      if (initialAuth != null) {
        await _secureStorage.write(key: _authKey, value: initialAuth);
        await preferences.remove(_authKey);
      }
    }
    final store = AsyncAuthStore(
      save: (String data) => _secureStorage.write(key: _authKey, value: data),
      initial: initialAuth,
      clear: () => _secureStorage.delete(key: _authKey),
    );
    instance = PocketBase(baseUrl, authStore: store);
  }

  static Future<void> clearAuthSession() async {
    instance.authStore.clear();
    await _secureStorage.delete(key: _authKey);
  }
}
