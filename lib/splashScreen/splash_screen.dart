import 'package:flutter/material.dart';
import 'package:hunger_box/authentication/auth_screen.dart';
import 'dart:async';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 4), () async {
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const AuthScreen()));
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
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/splashscreenimage.png"),
                Image.asset("images/logo.png"),
                const SizedBox(
                  height: 10,
                ),
              ],
            ))));
  }
}
