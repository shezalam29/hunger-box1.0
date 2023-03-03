import 'package:hunger_box/hungerbox_pref/hungerbox_pref.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  var sharedPreferences = await HungerBoxPreferences.getInstance();

  var avatar = "avatar";
  var uid = "123456";
  var name = "andy";
  var email = "aa@gmail.com";
  sharedPreferences.setAvatar(avatar);
  sharedPreferences.setUID(uid);
  sharedPreferences.setName(name);
  sharedPreferences.setEmail(email);

  assert(sharedPreferences.getAvatar() == avatar);
  assert(sharedPreferences.getUID() == uid);
  assert(sharedPreferences.getName() == name);
  assert(sharedPreferences.getEmail() == email);
}
