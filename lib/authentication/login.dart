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
                message: "Please type in your Email and Password.");
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(message: "Logging you in");
        });

    try {
      await FBH.login(
          emailController.text.trim(), passwordController.text.trim());
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: e.message.toString(),
            );
          });
      return;
    }

    if (FBH.currentUser == null) return;

    bool isVendor = await FBH.isVendor(FBH.currentUser!);

    String nameField, emailField, avatarField;
    if (isVendor) {
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
      return isVendor ? VendorHomeScreen() : UserHomeScreen();
    }));
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
