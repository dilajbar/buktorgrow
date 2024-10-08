import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'token';

  //Token
  static Future setToken(String token) async =>
      await _storage.write(key: _keyToken, value: token);

  static Future<String?> getToken() async {
    var token = await _storage.read(key: _keyToken);
    return token;
  }
  ///////////////////////////delete///////////////////////////////

  static Future<void> deletetoken() async {
    await _storage.delete(key: _keyToken);
  }
}
