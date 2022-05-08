import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String tareq = "tareq";

class Tareq extends StatefulWidget {
   const Tareq({Key? key}) : super(key: key);

  @override
  State<Tareq> createState() => _TareqState();
}

class _TareqState extends State<Tareq> {
  final user = FirebaseAuth.instance.currentUser!;
  getData() async {
    var userName = FirebaseFirestore.instance.collection("users").doc(user.uid);
    await userName.get().then((value) {
      print(value.data()!['name']);
      setState(() {
        tareq = value.data()!['name'].toString();
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(tareq),
      ),
    );
  }
}
