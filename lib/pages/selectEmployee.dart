import 'package:flutter/material.dart';

class SelectEmployee extends StatelessWidget {
  const SelectEmployee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: const Color(0xff141E27),
        title: const Text('Employee'),
        ),
    );
  }
}
