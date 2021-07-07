import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mydictionaryapp/src/domain/entities/user.dart';

const _TOKEN = 'token';
const _USERDATA = 'userData';

class StoreInteractor {
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_TOKEN) ?? '';
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_TOKEN, token);
  }

  Future<UserData?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_USERDATA) ?? '';
    try {
      return UserData.fromJson(jsonDecode(userData));
    } catch (_) {
      return null;
    }
  }

  Future<void> setUserData(UserData userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_USERDATA, jsonEncode(userData.toJson()));
  }

  Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
