// Shezan
// Nahin
// Andrew
// Alberto
// Parsha
// Ana
import 'package:flutter/material.dart';
import 'package:hunger_box/fb_handler/fb_handler.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/splashScreen/splash_screen.dart';
import 'package:hunger_box/hungerbox_pref/hungerbox_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await HungerBoxPreferences.getInstance();
  FBH = await FirebaseHandler.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySplashScreen(),
    );
  }
}
