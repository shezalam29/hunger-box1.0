import 'package:shared_preferences/shared_preferences.dart';

external Type get runtimeType;

/// Preferences wrapper for HungerBox project
class HungerBoxPreferences {
  static HungerBoxPreferences? _singleton;
  static late SharedPreferences _preferences;

  /// Field Variables
  static const String UID = "uid";
  static const String NAME = "name";
  static const String EMAIL = "email";
  static const String AVATAR = "avatarUrl";

  static Future<HungerBoxPreferences> getInstance() async {
    if (_singleton != null) return _singleton!;
    _singleton ??= HungerBoxPreferences._();
    _preferences = await SharedPreferences.getInstance();

    return _singleton!;
  }

  Future setUID(String val) async {
    await _preferences.setString(UID, val);
  }

  Future setName(String val) async {
    await _preferences.setString(NAME, val);
  }

  Future setEmail(String val) async {
    await _preferences.setString(EMAIL, val);
  }

  Future setAvatar(String val) async {
    await _preferences.setString(AVATAR, val);
  }

  String? getUID() {
    return _preferences.getString(UID);
  }

  String? getName() {
    return _preferences.getString(NAME);
  }

  String? getEmail() {
    return _preferences.getString(EMAIL);
  }

  String? getAvatar() {
    return _preferences.getString(AVATAR);
  }

  HungerBoxPreferences._();
}
