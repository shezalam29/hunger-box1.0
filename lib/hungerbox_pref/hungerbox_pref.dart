import 'package:shared_preferences/shared_preferences.dart';

/// Preferences wrapper for HungerBox project
class HungerBoxPreferences {
  static HungerBoxPreferences? _singleton;
  static late SharedPreferences _preferences;

  /// Field Variables
  final String _uid = "uid";
  final String _name = "name";
  final String _email = "email";
  final String _avatar = "avatarUrl";
  final String _cart = "cart";

  static Future<HungerBoxPreferences> getInstance() async {
    if (_singleton != null) return _singleton!;
    _singleton ??= HungerBoxPreferences._();
    _preferences = await SharedPreferences.getInstance();

    return _singleton!;
  }

  Future setPreferenceData(
      {uid = "", name = "", email = "", avatar = ""}) async {
    await setUID(uid);
    await setName(name);
    await setEmail(email);
    await setAvatar(avatar);
  }

  Future<bool> clearPreferenceData() async {
    return await _preferences.clear();
  }

  Future setUID(String val) async {
    await _preferences.setString(_uid, val);
  }

  Future setName(String val) async {
    await _preferences.setString(_name, val);
  }

  Future setEmail(String val) async {
    await _preferences.setString(_email, val);
  }

  Future setAvatar(String val) async {
    await _preferences.setString(_avatar, val);
  }

  Future initCart() async {
    await _preferences.setStringList(_cart, List<String>.empty());
  }

  Future emptyCart() async {
    await initCart();
  }

  String? getUID() {
    return _preferences.getString(_uid);
  }

  String? getName() {
    return _preferences.getString(_name);
  }

  String? getEmail() {
    return _preferences.getString(_email);
  }

  String? getAvatar() {
    return _preferences.getString(_avatar);
  }

  HungerBoxPreferences._();
}
