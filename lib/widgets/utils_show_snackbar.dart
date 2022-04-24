import 'package:flutter/material.dart';

class Utils {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: FittedBox(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor:  Colors.red.shade900,
      duration: const Duration(seconds: 5),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 55),
    );

    return messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
