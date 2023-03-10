import 'package:flutter/material.dart';

circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 12),
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Color.fromARGB(255, 120, 130, 100),
        ),
      ));
}

//Linear progress bar
linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const LinearProgressIndicator(
      backgroundColor: Color.fromARGB(255, 188, 169, 146),
      valueColor: AlwaysStoppedAnimation(
        Color.fromARGB(255, 120, 130, 100),
      ),
    ),
  );
}
