import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hunger_box/fb_handler/fb_handler.dart';

/// Shared local preferences
// TODO need to organize the preferences ot have consistent keys and names
// Should develop a wrapper class
SharedPreferences? sharedPreferences;

class PREFERENCES {
  static final String UID = "uid";
  static final String NAME = "name";
  static final String EMAIL = "email";
  static final String AVATAR = "avatarUrl";
}

/// Firebase Authentication
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

/// Firebase Handler for getting, setting, and modifying Firebase Data
late FirebaseHandler FBH;
