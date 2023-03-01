library lib.fb_handler.fb_handler;

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:hunger_box/global/fb_constants.dart';

class FirebaseHandler {
  /// Singleton to insure only single user is logged on
  static final FirebaseHandler _self = FirebaseHandler._();

  /// Cached local password
  late String _psswrd;

  /// cached Current User
  late User? currentUser;

  /// Cached path to the avatar image
  late String avatarUrl;

  /// Uses a [FirebaseHandler] factory to initalizes the app and return active
  /// handler
  static Future<FirebaseHandler> create() async {
    await Firebase.initializeApp();
    return _self;
  }

  FirebaseHandler._();

  /// Log in to Firebase with [usrName] and [psswrd].
  Future login(String usrName, String psswrd) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: usrName, password: psswrd)
        .then((usrCred) {
      currentUser = usrCred.user;
      _psswrd = psswrd;
    });
  }

  /// Gets the current logged in user's info
  Map<String, dynamic> getCurrentUserInfo() {
    var info = _getStudentInfo(currentUser!.uid.toString());

    if (info == null) {
      throw Exception("Fatal Error, current user has no information");
    }
    return info;
  }

  /// Register a new Student into the database with a hunterId, email, and password.
  /// Then inserts a document containing their information into the [studentUsers]
  /// collection, keyed to the users authentication [uid]
  Future registerNewStudent(
      String email, String psswrd, String studName, String imgPath) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: psswrd)
        .then((usrCred) {
      currentUser = usrCred.user;
      _psswrd = psswrd;
    });

    String imgName = DateTime.now().millisecondsSinceEpoch.toString();
    avatarUrl = await _uploadAvatarImage(imgName, imgPath, STUDENT_CLLCTN);

    await _insertNewUsrInfo(
        STUDENT_CLLCTN,
        currentUser!.uid,
        _mapStudentFields(
          currentPoints: 0,
          email: email.trim(),
          firstName: studName.trim(),
          uid: currentUser!.uid,
          avatarUrl: avatarUrl,
        ));
  }

  Future registerNewVendor(String name, String email, String psswrd,
      String address, String imagePath, double lat, double lng) async {
    final fbhInst = FirebaseAuth.instance;
    await fbhInst
        .createUserWithEmailAndPassword(email: email, password: psswrd)
        .then((usrCred) {
      currentUser = usrCred.user;
      _psswrd = psswrd;
    });

    String imgName = DateTime.now().millisecondsSinceEpoch.toString();
    avatarUrl = await _uploadAvatarImage(imgName, imagePath, VENDOR_CLLCTN);

    String? currUserId = currentUser?.uid;

    await _insertNewUsrInfo(
        VENDOR_CLLCTN,
        currUserId!,
        _mapVendorFields(
          address: address.trim(),
          earnings: 0,
          vendorEmail: email.trim(),
          vendorAvatarUrl: avatarUrl,
          lat: lat,
          lng: lng,
          status: "approved",
          vendorName: name.trim(),
          vendorUID: currUserId,
        ));
  }

  // ============================ PRIVATE METHODS ============================

  /// Get info of the document attached to a [uid]
  Map<String, dynamic>? _getStudentInfo(String uid) {
    final docRef = FirebaseFirestore.instance.collection(STUDENT_CLLCTN);
    docRef.doc(uid).get().then((value) {
      if (!value.exists) {
        return null;
      } else {
        return value.data();
      }
    });
  }

  /// Insert a New user into a [collection] with a key of [key] and [values]
  Future<bool> _insertNewUsrInfo(
      String collection, String key, Map<String, dynamic> values) async {
    final docRef = FirebaseFirestore.instance.collection(collection);
    docRef.doc(key).get().then((usr) async {
      if (usr.exists) {
        return false;
      } else {
        await usr.reference.set(values);
      }
    });
    return true;
  }

  /// Upload an avatar image into [fstorage] and return the resulting path
  Future<String> _uploadAvatarImage(
      String imgName, String imgPath, String collection) async {
    fstorage.Reference reference = fstorage.FirebaseStorage.instance
        .ref()
        .child(collection)
        .child(imgName);

    fstorage.UploadTask uploadTask = reference.putFile(File(imgPath));
    fstorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  /// Map variables to the student fields safely.
  /// If a field is not provided or does not exist (yet), then it can be set
  /// to a default value
  Map<String, dynamic> _mapStudentFields({
    int currentPoints = 0,
    String email = "",
    String firstName = "",
    String avatarUrl = "not found",
    int hunterId = -1,
    String uid = "NOTSET",
  }) {
    Map<String, dynamic> fields = {
      STUDENT.POINTS: currentPoints,
      STUDENT.EMAIL: email,
      STUDENT.FIRST_NAME: firstName,
      STUDENT.AVATAR_URL: avatarUrl,
      STUDENT.UID: uid,
      // STUDENT.HUNTERID: hunterId, // IMPLEMENT LATER
    };

    return fields;
  }

  /// Map variables to the Vendor fields safely.
  /// If a field is not provided or does not exist (yet), then it can be set
  /// to a default value
  Map<String, dynamic> _mapVendorFields({
    address = "",
    earnings = 0,
    vendorEmail = "",
    vendorAvatarUrl = "",
    lat = -1,
    lng = -1,
    status = "",
    vendorName = "",
    vendorUID = "",
  }) {
    Map<String, dynamic> fields = {
      VENDOR.ADDRESS: address,
      VENDOR.EARNINGS: earnings,
      VENDOR.LAT: vendorEmail,
      VENDOR.LNG: vendorAvatarUrl,
      VENDOR.STATUS: lat,
      VENDOR.AVATAR_URL: lng,
      VENDOR.EMAIL: status,
      VENDOR.NAME: vendorName,
      VENDOR.UID: vendorUID,
    };

    return fields;
  }
}
