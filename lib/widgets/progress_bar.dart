import 'package:flutter/material.dart';

circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 12),
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Colors.blue,
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
        Colors.blue,
      ),
    ),
  );
}
