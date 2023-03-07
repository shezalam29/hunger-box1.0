import 'package:flutter/material.dart';
import 'package:hunger_box/authentication/auth_screen.dart';
import 'dart:async';

import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/mainScreens/vendor_home_screen.dart';
import 'package:hunger_box/mainScreens/user_home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
      if (firebaseAuth.currentUser != null) {
        bool isVendor = await FBH.isVendor(FBH.currentUser!);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) {
                  return isVendor ? const VendorHomeScreen() : UserHomeScreen();
                },
                fullscreenDialog: true));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => const AuthScreen(), fullscreenDialog: true));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            color: const Color.fromARGB(255, 120, 130, 100),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "HUNGER BOX",
                  style: TextStyle(
                    color: Color.fromARGB(241, 255, 215, 194),
                    fontSize: 60,
                    fontFamily: "Raleway-Bold",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ))));
  }
}
