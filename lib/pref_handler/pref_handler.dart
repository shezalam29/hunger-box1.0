import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

class HungerBoxPreferences {
  static HungerBoxPreferences? _local;
  static SharedPreferences? _preferences;

  static Future<HungerBoxPreferences> getInstance() async {
    _local ??= HungerBoxPreferences._();
    _preferences ??= await SharedPreferences.getInstance();

    return _local!;
  }

  HungerBoxPreferences._();
}
