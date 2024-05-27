import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  Future<void> saveSession(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
  }

  Future<Map<String, String>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(_usernameKey);
    String? password = prefs.getString(_passwordKey);

    return {
      'username': username ?? '',
      'password': password ?? '',
    };
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
  }

  Future<void> endService() async {
    await clearSession();
  }
}
