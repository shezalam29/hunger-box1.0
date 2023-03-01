import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hunger_box/fb_handler/fb_handler.dart';

/// Shared local preferences
SharedPreferences? sharedPreferences;

/// Firebase Authentication
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

/// Firebase Handler for getting, setting, and modifying Firebase Data
late FirebaseHandler FBH;
