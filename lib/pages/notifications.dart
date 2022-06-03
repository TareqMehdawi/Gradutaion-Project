import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/widgets/user_class.dart';

import 'navigation_drawer.dart';

class UserNotifications extends StatefulWidget {
  const UserNotifications({Key? key}) : super(key: key);

  @override
  State<UserNotifications> createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String? time;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
        backgroundColor: const Color(0xff205375),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => NavigationDrawer()));
          },
        ),
      ),
      body: StreamBuilder<List<Notifications>>(
          stream: readNotification(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(12.0),
                children: [...users.map(buildListTile).toList()],
              );
            } else {
              return splashScreen();
            }
          }),
    );
  }

  Widget buildListTile(Notifications user) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user.date),
            ],
          ),
          title: Text(user.title),
          subtitle: Text('${user.body}  ${user.time}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  time = user.time;
                  final delete = await FirebaseFirestore.instance
                      .collection('notification')
                      .where('id', isEqualTo: currentUser.uid)
                      .where('time', isEqualTo: time)
                      .get();

                  var deleted = delete.docs.first;
                  await FirebaseFirestore.instance
                      .collection('notification')
                      .doc(deleted.id)
                      .delete();
                },
                borderRadius: BorderRadius.circular(50),
                child: const Icon(
                  Icons.delete,
                  size: 25,
                ),
              ),
            ],
          ),
          tileColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34.0),
          ),
        ),
      );

  Stream<List<Notifications>> readNotification() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('notification')
        .where("id", isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Notifications.fromJson(doc.data()))
            .toList());
  }
}
