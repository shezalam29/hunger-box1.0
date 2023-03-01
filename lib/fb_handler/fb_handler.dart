library lib.fb_handler.fb_handler;

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;


class FirebaseHandler {
  /// Singleton to insure only single user is logged on
  static final FirebaseHandler _self = FirebaseHandler._();

  /// Cached local user name
  late final String _usrName;

  /// Cached local password
  late final String _psswrd;

  /// cached Current User
  late User? currentUser;

  /// Uses a [FirebaseHandler] factory to initalizes the app and return active
  /// handler
  static Future<FirebaseHandler> create() async {
    await Firebase.initializeApp();
    return _self;
  }

  FirebaseHandler._();

  /// Log in to Firebase with [usrName] and [psswrd].
  Future login(String usrName, String psswrd) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: usrName, password: psswrd)
          .then((usrCred) {
        currentUser = usrCred.user;
        _usrName = usrName;
        _psswrd = psswrd;
      });
    } catch (e) {
      // TODO throw some kind of error message for failed sign in
    }
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
  Future<bool> registerNewStudent(String email, String psswrd,
      {String firstName = "", String lastName = "", int hunterId = -1}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: psswrd)
          .then((usrCred) {
        currentUser = usrCred.user;
        _usrName = email;
        _psswrd = psswrd;
      });
    } catch (e) {
      print(e);
      return false;
    }

    print("Inserting new student");
    return await _insertNewUsrInfo(
        "studentUsers", currentUser!.uid, <String, dynamic>{
      "currentPoints": 0,
      "email": email.trim(),
      "firstName": firstName.trim(),
      "lastName": lastName.trim(),
      "userId": hunterId,
    });
  }

  Future<bool> registerNewVendor(String name, String email, String psswrd,
      String address, String imagePath, double lat, double lng) async {
    final fbhInst = FirebaseAuth.instance;
    try {
      await fbhInst
          .createUserWithEmailAndPassword(email: email, password: psswrd)
          .then((usrCred) {
        currentUser = usrCred.user;
        _usrName = email;
        _psswrd = psswrd;
      });
    } catch (e) {
      print(e);
      // TODO throw some kind of error message for failed creation
      return false;
    }

    String imgName = DateTime.now().millisecondsSinceEpoch.toString();
    String imgUrl = await _uploadVendorImage(imgName, imagePath);

    String? currUserId = currentUser?.uid;
    return await _insertNewUsrInfo("vendors", currUserId!, <String, dynamic>{
      "address": address.trim(),
      "earnings": 0,
      "vendorEmail": email.trim(),
      "vendorAvatarUrl": imgUrl,
      "lat": lat,
      "lng": lng,
      "status": "approved",
      "vendorName": name.trim(),
      "vendorUID": currUserId,
    });
  }

  // ============================ PRIVATE METHODS ============================

  /// Get info of the document attached to a [uid]
  Map<String, dynamic>? _getStudentInfo(String uid) {
    final docRef = FirebaseFirestore.instance.collection("studentUsers");
    docRef.doc(uid).get().then((value) {
      if (!value.exists) {
        print("User does not exist");
        return null;
      } else {
        return value.data();
      }
    });
  }

  Future<bool> _insertNewUsrInfo(
      String collection, String usrId, Map<String, dynamic> values) async {
    print("Inserting new user");
    final docRef = FirebaseFirestore.instance.collection(collection);
    // docRef.doc(usrId).set(values);
    docRef.doc(usrId).get().then((usr) async {
      if (usr.exists) {
        // This shouldn't occur, but could
        print("UserID already exists");
        return false;
      } else {
        await usr.reference.set(values);
      }
    });
    return true;
  }

  Future<String> _uploadVendorImage(String imgName, String imgPath) async {
    // TODO not returning the proper url to the image
    fstorage.Reference reference =
        fstorage.FirebaseStorage.instance.ref().child("vendors").child(imgName);
    fstorage.UploadTask uploadTask = reference.putFile(File(imgPath));
    fstorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();
    print(url);
    return url;
    //   await taskSnapshot.ref.getDownloadURL().then((url) {
    //     return url;
    //     // save registration information to firestore
    //   });
    //   return "FAILURE";
  }
}
