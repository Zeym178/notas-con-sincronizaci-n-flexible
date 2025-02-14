import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static const String _isGuestKey = 'isGuest';

  static Future setGuestMode(bool isGuest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGuestKey, isGuest);
    print(prefs.getBool(_isGuestKey));
  }

  static Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool(_isGuestKey));
    return prefs.getBool(_isGuestKey) ?? false;
  }

  static Future removeGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isGuestKey);
    print(prefs.getBool(_isGuestKey));
  }
}
