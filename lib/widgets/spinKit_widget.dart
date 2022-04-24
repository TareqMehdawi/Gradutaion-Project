import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinKitWidget extends StatelessWidget {
  const SpinKitWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
      child: SpinKitCircle(
        size: 150,
        color: Color(0xff141E27),
      ),),
    );
  }
}