import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/global/fb_constants.dart';
import 'package:hunger_box/mainScreens/home_screen.dart';
import 'package:hunger_box/widgets/custom_text_field.dart';
import 'package:hunger_box/widgets/error_dialog.dart';
import 'package:hunger_box/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
                message: "Please type in youer email and password.");
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(message: "Loggin you in.");
        });

    User? currentUser;

    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    await FBH.isVendor(currentUser!);

    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      });
    }
  }

  // TODO this is a duplicate from registration.dart, find a way to consolidate
  // into one function.
  // SharedPreferences Handler?
  // TODO inconsistent fields to the firebase
  // TODO needs to check who the user is
  Future readDataAndSetDataLocally(User currentUser) async {
    if (await FBH.isVendor(currentUser)) {
      await FirebaseFirestore.instance
          .collection(vendorCllctn)
          .doc(currentUser.uid)
          .get()
          .then((document) async {
        await sharedPreferences.setUID(currentUser.uid);
        await sharedPreferences.setName(document.data()![VendorDoc.name]);
        await sharedPreferences.setEmail(document.data()![VendorDoc.email]);
        await sharedPreferences
            .setAvatar(document.data()![VendorDoc.avatarUrl]);
      });
    } else {
      await FirebaseFirestore.instance
          .collection(studentCllctn)
          .doc(currentUser.uid)
          .get()
          .then((document) async {
        await sharedPreferences.setUID(currentUser.uid);
        await sharedPreferences.setName(document.data()![StudentDoc.name]);
        await sharedPreferences.setEmail(document.data()![StudentDoc.email]);
        await sharedPreferences
            .setAvatar(document.data()![StudentDoc.avatarUrl]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "images/logo.png",
                height: 150,
                width: 300,
              ),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObscure: true,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(25, 117, 244, 100),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
            onPressed: () {
              formValidation();
            },
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
