import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenRepository {
  static const String _tokenKey = 'authToken';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  Future<int?> getUserId() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      if (JwtDecoder.isExpired(token)) {
        return null;
      }

      final decoded = JwtDecoder.decode(token);

      final id = decoded['sub'];
      if (id is int) return id;
      if (id is String) return int.tryParse(id);

      return null;
    } catch (e) {
      return null;
    }
  }
}
