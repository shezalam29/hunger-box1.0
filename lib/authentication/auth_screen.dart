import 'package:flutter/material.dart';
import 'package:hunger_box/authentication/login.dart';
import 'package:hunger_box/authentication/registration.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 222, 177, 118),
                Color.fromARGB(155, 12, 43, 38),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
          ),
          title: const Text(
            "Welcome",
            style: TextStyle(
              fontSize: 80,
              color: Color.fromARGB(255, 212, 182, 171),
              fontFamily: "Raleway",
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock, color: Colors.white),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.white),
                text: "Register",
              ),
            ],
            /*indicatorColor: Color.fromARGB(19, 38, 112, 40),
            indicatorWeight: 2, */
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 222, 177, 118),
              Color.fromARGB(155, 12, 43, 38),
            ],
          )),
          /*child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ), */
        ),
      ),
    );
  }
}
