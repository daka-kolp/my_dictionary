import 'package:shared_preferences/shared_preferences.dart';

const _TOKEN = 'token';

class StoreInteractor {
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_TOKEN) ?? '';
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_TOKEN, token);
  }

  Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
