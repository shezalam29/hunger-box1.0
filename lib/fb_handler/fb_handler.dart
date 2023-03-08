import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:hunger_box/global/global.dart';

class FirebaseHandler {
  /// Singleton to insure only single user is logged on
  static final FirebaseHandler _self = FirebaseHandler._();

  /// Cached local password
  late String _psswrd;

  /// cached Current User
  User? currentUser;

  /// Cached path to the avatar image
  late String avatarUrl;

  /// Cached boolean for if current user is vendor
  bool? _isVendor;

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
        .then((usrCred) async {
      currentUser = usrCred.user;
      _psswrd = psswrd;
      _isVendor = await isVendor(usrCred.user!);
    });
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    currentUser = null;
    _psswrd = "";
    _isVendor = null;
  }

  /// Gets the current logged in user's info
  Future<DocumentSnapshot<Map<String, dynamic>>?> getCurrentUserInfo() async {
    if (currentUser == null) {
      return null;
    }
    String cllctn = _isVendor! ? vendorCllctn : studentCllctn;
    return _getDocumentData(cllctn, currentUser!.uid);
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
      _isVendor = false;
    });

    String imgName = DateTime.now().millisecondsSinceEpoch.toString();
    avatarUrl = await _uploadAvatarImage(imgName, imgPath, studentCllctn);

    await _insertNewUsrInfo(
        studentCllctn,
        currentUser!.uid,
        _mapStudentFields(
          currentPoints: 0,
          email: email.trim(),
          firstName: studName.trim(),
          uid: currentUser!.uid,
          avatarUrl: avatarUrl,
        ));
  }

  /// Register a new Vendor into the database
  Future registerNewVendor(String name, String email, String psswrd,
      String address, String imagePath, double lat, double lng) async {
    final fbhInst = FirebaseAuth.instance;
    await fbhInst
        .createUserWithEmailAndPassword(email: email, password: psswrd)
        .then((usrCred) {
      currentUser = usrCred.user;
      _psswrd = psswrd;
      _isVendor = true;
    });

    String imgName = DateTime.now().millisecondsSinceEpoch.toString();
    avatarUrl = await _uploadAvatarImage(imgName, imagePath, vendorCllctn);

    String? currUserId = currentUser?.uid;

    await _insertNewUsrInfo(
        vendorCllctn,
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

  Future uploadMenuItem(String vendorDocID, MenuItem m) async {
    final cllctnRef =
        getDocument(vendorCllctn, vendorDocID).collection(menusCllctn);

    await cllctnRef.doc(m.fields[MenusDoc.menuID]).set(m.fields);
  }

  /// Check whether provided [usr] is a Vendor by checking if they exist within
  /// the Vendor Collection. Caches the response if there isn't already one
  Future<bool> isVendor(User usr) async {
    _isVendor ??= await _getDocumentData(vendorCllctn, usr.uid).then((usr) {
      return usr.exists;
    });

    return _isVendor!;
  }

  DocumentReference<Map<String, dynamic>> getDocument(
      String cllctn, String docId) {
    return getCollection(cllctn).doc(docId);
  }

  CollectionReference<Map<String, dynamic>> getCollection(String cllctn) {
    return FirebaseFirestore.instance.collection(cllctn);
  }

  // ============================ PRIVATE METHODS ============================

  /// Get the document attached to a [docId] in a [cllctn]
  Future<DocumentSnapshot<Map<String, dynamic>>> _getDocumentData(
      String cllctn, String docId) {
    return getDocument(cllctn, docId).get();
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
      StudentDoc.points: currentPoints,
      StudentDoc.email: email,
      StudentDoc.name: firstName,
      StudentDoc.avatarUrl: avatarUrl,
      StudentDoc.uid: uid,
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
      VendorDoc.address: address,
      VendorDoc.earnings: earnings,
      VendorDoc.lat: lat,
      VendorDoc.lng: lng,
      VendorDoc.status: status,
      VendorDoc.avatarUrl: vendorAvatarUrl,
      VendorDoc.email: vendorEmail,
      VendorDoc.name: vendorName,
      VendorDoc.uid: vendorUID,
    };

    return fields;
  }
}
