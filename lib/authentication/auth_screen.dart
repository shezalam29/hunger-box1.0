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
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 120, 130, 100)),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon:
                    Icon(Icons.lock, color: Color.fromARGB(255, 255, 255, 255)),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.person,
                    color: Color.fromARGB(255, 255, 255, 255)),
                text: "Register",
              ),
            ],
          ),
        ),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
          child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
