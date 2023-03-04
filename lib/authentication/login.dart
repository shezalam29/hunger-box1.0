import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/mainScreens/vendor_home_screen.dart';
import 'package:hunger_box/mainScreens/user_home_screen.dart';
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
          return LoadingDialog(message: "Loggin you in");
        });

    await FBH
        .login(emailController.text.trim(), passwordController.text.trim())
        .catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if (FBH.currentUser == null) return;

    bool _isVendor = await FBH.isVendor(FBH.currentUser!);

    if (FBH.currentUser != null) {
      String nameField, emailField, avatarField;
      if (_isVendor) {
        nameField = VendorDoc.name;
        emailField = VendorDoc.email;
        avatarField = VendorDoc.avatarUrl;
      } else {
        nameField = StudentDoc.name;
        emailField = StudentDoc.email;
        avatarField = StudentDoc.avatarUrl;
      }

      await FBH.getCurrentUserInfo().then((doc) async {
        Map<String, dynamic> data = doc!.data()!;
        await sharedPreferences.setPreferenceData(
            uid: FBH.currentUser!.uid,
            name: data[nameField],
            email: data[emailField],
            avatar: data[avatarField]);
      });

      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c) {
        return _isVendor ? VendorHomeScreen() : UserHomeScreen();
      }));
    }
  }

  // TODO this is a duplicate from registration.dart, find a way to consolidate
  // into one function.
  // SharedPreferences Handler?
  // TODO needs to check who the user is
  Future readDataAndSetDataLocally(User currentUser) async {
    if (await FBH.isVendor(currentUser)) {
      await FirebaseFirestore.instance
          .collection(vendorCllctn)
          .doc(currentUser.uid)
          .get()
          .then((document) async {
        await sharedPreferences.setPreferenceData(
            uid: currentUser.uid,
            name: document.data()![VendorDoc.name],
            email: document.data()![VendorDoc.email],
            avatar: document.data()![VendorDoc.avatarUrl]);
      });
    } else {
      await FirebaseFirestore.instance
          .collection(studentCllctn)
          .doc(currentUser.uid)
          .get()
          .then((document) async {
        await sharedPreferences.setPreferenceData(
            uid: currentUser.uid,
            name: document.data()![StudentDoc.name],
            email: document.data()![StudentDoc.email],
            avatar: document.data()![StudentDoc.avatarUrl]);
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
