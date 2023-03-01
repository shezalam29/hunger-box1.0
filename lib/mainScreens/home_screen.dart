import 'package:flutter/material.dart';
import 'package:hunger_box/authentication/auth_screen.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/uploadScreen/menus_upload.dart';

import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 188, 169, 146),
              Color.fromARGB(255, 120, 130, 100),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: Text(
          sharedPreferences!.getString(PREFERENCES.NAME)!,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add, color: Colors.orange),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const MenusUpload()));
            },
          ),
        ],
      ),

      // ignore: prefer_const_constructors
      drawer: MyDrawer(),
      body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          style: ElevatedButton.styleFrom(
            primary: Colors.cyan,
          ),
          onPressed: () {
            firebaseAuth.signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => AuthScreen()));
          },
        ),
      ),
    );
  }
}
