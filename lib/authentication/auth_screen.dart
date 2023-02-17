import 'package:flutter/material.dart';
import 'package:hunger_box/authentication/login.dart';
import 'package:hunger_box/authentication/registration.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
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
                    Colors.blue,
                    Colors.red,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 0.1],
                  tileMode: TileMode.clamp,
                )),
              ),
              title: const Text(
                "HungerBox",
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.lock, color: Colors.blue),
                    text: "Login",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    text: "Register",
                  ),
                ],
                indicatorColor: Colors.black45,
                indicatorWeight: 8,
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.red,
                  Colors.blue,
                ],
              )),
              child: const TabBarView(
                children: [
                  LoginScreen(),
                  RegisterScreen(),
                ],
              ),
            )));
  }
}
