import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hunger_box/fb_handler/fb_handler.dart';
import 'package:hunger_box/hungerbox_pref/hungerbox_pref.dart';

/// Shared local preferences
late HungerBoxPreferences sharedPreferences;
const String nameField = HungerBoxPreferences.NAME;
const String emailField = HungerBoxPreferences.EMAIL;
const String avatarField = HungerBoxPreferences.AVATAR;
const String uidField = HungerBoxPreferences.UID;

/// Firebase Authentication
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

/// Firebase Handler for getting, setting, and modifying Firebase Data
late FirebaseHandler FBH;
