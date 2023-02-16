import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  _AuthScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthScreen> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "HungerBox",
            style: TextStyle(
              fontSize: 89,
              color: Colors.brown,
            ),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
