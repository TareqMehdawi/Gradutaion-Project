import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/user_class.dart';

String tareq = "tareq";

class Tareq extends StatefulWidget {
  const Tareq({Key? key}) : super(key: key);

  @override
  State<Tareq> createState() => _TareqState();
}

class _TareqState extends State<Tareq> {
  final user = FirebaseAuth.instance.currentUser!;
  var newDoc = [];

  // getData() async {
  //   var userName = FirebaseFirestore.instance.collection("users");
  //   await userName.doc().get().then((value) {
  //     print(value.data()!['name']);
  //     setState(() {
  //       tareq = value.data()!['name'].toString();
  //     });
  //   });
  // }
  // Stream<List<StudentsReservation>> readDoc() {
  //   final currentUser = FirebaseAuth.instance.currentUser!;
  //    final tareq = FirebaseFirestore.instance.collection('doctors').where('name').snapshots().map(
  //           (snapshot) =>
  //           snapshot.docs
  //               .map((doc) => StudentsReservation.fromJson(doc.data()))
  //               .toList());
  //    print(tareq);
  //   return tareq;
  // }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('doctors');

  Future<List> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc['name']).toList();
    allData.sort();
    for (int i = 0; i < allData.length; i++) {
      setState(() {
        newDoc = allData.map((e) => e).toList();
      });
    }
    return newDoc;
  }

  @override
  void initState() {
    getData();
    // readDoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: newDoc.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text(newDoc[index].toString()),
          );
        },
      ),
    );
  }
}
