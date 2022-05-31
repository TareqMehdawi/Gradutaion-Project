import 'package:flutter/material.dart';

Widget customBackButton({required Color color}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Builder(builder: (context) {
        return IconButton(
          padding: EdgeInsets.all(10),
          iconSize: 30.0,
          icon: Icon(Icons.arrow_back),
          color: color,
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }),
    ],
  );
}
