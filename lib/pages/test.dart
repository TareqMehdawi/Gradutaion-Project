import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String tareq = "tareq";

class Tareq extends StatefulWidget {
  const Tareq({Key? key}) : super(key: key);

  @override
  State<Tareq> createState() => _TareqState();
}

class _TareqState extends State<Tareq> {
  bool s = false;
  bool m = false;
  String hour =  TimeOfDay.now().hourOfPeriod.toString().padLeft(2,'0');
  String minutes = TimeOfDay.now().minute.toString().padLeft(2,'0');
  final user = FirebaseAuth.instance.currentUser!;
  // var newDoc = [];

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

  // final CollectionReference _collectionRef =
  //     FirebaseFirestore.instance.collection('users');
  //
  // Future<List> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc['id']).toList();
  //   allData.sort();
  //   for (int i = 0; i < allData.length; i++) {
  //     setState(() {
  //       newDoc = allData.map((e) => e).toList();
  //     });
  //   }
  //   return newDoc;
  // }

  // FirebaseMessaging notification = FirebaseMessaging.instance;
  //
  // getNotifi() async{
  //   NotificationSettings settings = await notification.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   print('User granted permission: ${settings.authorizationStatus}');
  // }

  //
  // @override
  // void initState() {
  //   getData();
  //   // getNotifi();
  //   // readDoc();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children:[
          listTile(),
          listTile(),
        ]
      ),
    );
  }
  Widget listTile(){
    return ListTile(
      leading: const Icon(Icons.add) ,
      title: Text("$hour : $minutes"),
      onTap: (){
        setState(() {
        });
      },
    );
  }
  addTime({required String t}){
    String t = hour;
    switch(t){
      case '11:11':
    }
  }
}
