library lib.globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hunger_box/fb_handler/fb_handler.dart';
import 'package:hunger_box/hungerbox_pref/hungerbox_pref.dart';

part 'fb_constants.dart';

/// Shared local preferences
late HungerBoxPreferences sharedPreferences;

/// Firebase Authentication
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

/// Firebase Handler for getting, setting, and modifying Firebase Data
late FirebaseHandler FBH;
