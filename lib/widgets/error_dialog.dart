import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  ErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 255, 130, 121),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Center(
            child: Text("OK"),
          ),
        ),
      ],
    );
  }
}
