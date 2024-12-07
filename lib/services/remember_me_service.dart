import 'package:shared_preferences/shared_preferences.dart';

class RememberMeService {
  static const _keyRememberMe = 'remember_me';
  static const _keyEmail = 'saved_email';
  static const _keyPassword = 'saved_password';

  // Save "Remember Me" state and credentials
  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, true);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
  }

  // Clear "Remember Me" data
  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, false);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
  }

  // Get "Remember Me" state
  Future<bool> isRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  // Get saved email and password
  Future<Map<String, String?>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_keyEmail),
      'password': prefs.getString(_keyPassword),
    };
  }
}
