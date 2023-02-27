import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var fbh = FirebaseHandler();

  fbh.insertNewStudent(
    23897506,
    email: "aauyong11@gmail.com",
    firstName: "Andrew",
    lastName: "Auyong",
    password: "12345",
  );
}

class FirebaseHandler {
  FirebaseHandler() {
    _initializeApp("aauyong11@gmail.com", "password");
  }

  void _initializeApp(String user_name, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: user_name, password: password);
  }

  
  void insertNewStudent(int hunterId,
      {String email = "",
      String firstName = "",
      String lastName = "",
      String password = ""}) {
    final docRef = FirebaseFirestore.instance.collection("studentUsers");

    docRef.doc(hunterId.toString()).set(<String, dynamic>{
      "currentPoints": 0,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "password": password,
      "userId": hunterId
    });
  }
}
