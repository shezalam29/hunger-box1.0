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

/// File containing
const String vendorCllctn = "vendors";

class VendorDoc {
  static const String address = "address";
  static const String earnings = "earnings";
  static const String lat = "lat";
  static const String lng = "lng";
  static const String status = "status";
  static const String avatarUrl = "vendorAvatarUrl";
  static const String email = "email";
  static const String name = "name";
  static const String uid = "vendorUID";
}

const String studentCllctn = "students";

class StudentDoc {
  static const String points = "currentPoints";
  static const String email = "email";
  static const String name = "name";
  static const String avatarUrl = "studentAvatarUrl";

  /// Not yet implemented
  // static const String HUNTERID = "hunterId";
  static const String uid = "studentUID";
}
