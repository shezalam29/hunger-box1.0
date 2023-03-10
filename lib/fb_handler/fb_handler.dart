import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:hunger_box/global/global.dart';

class FirebaseHandler {
  /// Singleton to insure only single user is logged on
  static FirebaseHandler? _self;

  /// Cached local password
  late String _psswrd;

  /// cached Current User
  User? currentUser;

  /// Cached path to the avatar image
  late String avatarUrl;

  /// Cached boolean for if current user is vendor
  bool? _isVendor;

  /// Getter for [_isVendor]
  /// If it hasn't been set for some reason, queries the user, caches the
  /// variable, and then returns it.
  Future<bool> get isVendor async {
    if (currentUser == null) return false;
    _isVendor ??= await _isUserVendor(currentUser!);
    return _isVendor!;
  }

  /// Uses a [FirebaseHandler] factory to initalizes the app and return active
  /// handler
  static Future<FirebaseHandler> create() async {
    await Firebase.initializeApp();
    _self ??= FirebaseHandler._();
    return _self!;
  }

  /// Hidden constructor.
  /// Sets current user if there is a cached one in the [FirebaseAuth]
  FirebaseHandler._() {
    if (firebaseAuth.currentUser != null) {
      currentUser = firebaseAuth.currentUser;
    }
  }

  /// Log in to Firebase with [usrName] and [psswrd].
  Future login(String usrName, String psswrd) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: usrName, password: psswrd)
        .then((usrCred) async {
      currentUser = usrCred.user;
      _psswrd = psswrd;
      _isVendor = await _isUserVendor(usrCred.user!);
    });
  }

  /// Log out of Firebase and unset any local variables
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
    avatarUrl = await uploadImage(imgName, imgPath, studentCllctn);

    await _insertNewUsrInfo(
        studentCllctn,
        currentUser!.uid,
        Student(
          currentPoints: 0,
          email: email.trim(),
          firstName: studName.trim(),
          uid: currentUser!.uid,
          avatarUrl: avatarUrl,
        ).fields);
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
    avatarUrl = await uploadImage(imgName, imagePath, vendorCllctn);

    String? currUserId = currentUser?.uid;

    await _insertNewUsrInfo(
      vendorCllctn,
      currUserId!,
      Vendor(
        address: address.trim(),
        earnings: 0,
        vendorEmail: email.trim(),
        vendorAvatarUrl: avatarUrl,
        lat: lat,
        lng: lng,
        status: "approved",
        vendorName: name.trim(),
        vendorUID: currUserId,
      ).fields,
    );
  }

  //------------------------------ CART METHODS ------------------------------
  Future addItemToCurrentUserCart(CartItem ci) async {
    var docRef = getDocument(studentCllctn, currentUser!.uid);
    await docRef.collection(cartCllctn).add(ci.fields);
  }

  Future removeItemFromCurrentUserCart(String cartItemId) async {
    var docRef = FirebaseFirestore.instance
        .collection(studentCllctn)
        .doc(currentUser!.uid);
    await docRef.collection(cartCllctn).doc(cartItemId).delete();
  }

  Future emptyCurrentUserCart() async {
    var snapshot = FirebaseFirestore.instance
        .collection(studentCllctn)
        .doc(currentUser!.uid)
        .collection(cartCllctn)
        .snapshots();
    snapshot.forEach((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }
  // CART METHODS

  Future uploadMenuItem(String vendorDocID, MenuItem m) async {
    final cllctnRef =
        getDocument(vendorCllctn, vendorDocID).collection(itemsCllctn);

    await cllctnRef.doc(m.fields[ItemsDoc.itemID]).set(m.fields);
  }

  /// Edit/Update a specified [MenuItem] in the Firebase database, located
  /// under the specified vendor, using the values in [edited]. Ensures that
  Future editMenuItem(
      String vendorDocId, String menuId, Map<String, dynamic> edited) async {
    await getDocument(vendorCllctn, vendorDocId)
        .collection(itemsCllctn)
        .doc(menuId)
        .get()
        .then((item) async {
      if (item.exists) {
        item.reference.set(
          edited,
          SetOptions(
              mergeFields:
                  ItemsDoc.fields.where((f) => edited.containsKey(f)).toList()),
        );
      }
    });
  }

  /// Delete a specified [MenuItem] in the Firebase database, located
  /// under the specified vendor.
  Future deleteMenuItem(String vendorDocId, String menuId) async {
    await getDocument(vendorCllctn, vendorDocId)
        .collection(itemsCllctn)
        .doc(menuId)
        .get()
        .then((item) async {
      if (item.exists) {
        item.reference.delete();
      }
    });
  }

  DocumentReference<Map<String, dynamic>> getDocument(
      String cllctn, String docId) {
    return FirebaseFirestore.instance.collection(cllctn).doc(docId);
  }

  CollectionReference<Map<String, dynamic>> getCollection(String cllctn) {
    return FirebaseFirestore.instance.collection(cllctn);
  }

  /// Upload an avatar image into [fstorage] and return the resulting path
  Future<String> uploadImage(
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

  // ============================ PRIVATE METHODS ============================
  /// Helper function to check if
  Future<bool> _isUserVendor(User u) async {
    return await _getDocumentData(vendorCllctn, u.uid).then((usr) {
      return usr.exists;
    });
  }

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
}
