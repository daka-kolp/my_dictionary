import 'package:shared_preferences/shared_preferences.dart';

const _TOKEN = 'token';

class StoreInteractor {
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_TOKEN);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_TOKEN, token);
  }

  static Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
