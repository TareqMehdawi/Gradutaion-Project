import 'package:awesome_dialog/awesome_dialog.dart';
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
              if(users.isEmpty){
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.1),
                      child: Image.asset('assets/images/Notify-amico.png'),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  "You have no notification",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color(0xff205375),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                );


              }

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
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Warning',
                      desc: 'Are you sure you want to delete this service',
                      btnOkText: "Delete",
                      btnCancelText: 'Cancel',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
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
                        AwesomeDialog(
                          autoDismiss: false,
                          context: context,
                          dialogType: DialogType.SUCCES,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Success',
                          desc: 'Notification deleted successfully',
                          btnOkText: 'Go back',
                          btnCancelColor: Colors.black87,
                          onDissmissCallback: (d) {
                            Navigator.pop(context);
                          },
                          btnOkOnPress: () {
                            Navigator.pop(context);
                          },
                        ).show();
                      }).show();

                  // time = user.time;
                  // final delete = await FirebaseFirestore.instance
                  //     .collection('notification')
                  //     .where('id', isEqualTo: currentUser.uid)
                  //     .where('time', isEqualTo: time)
                  //     .get();
                  //
                  // var deleted = delete.docs.first;
                  // await FirebaseFirestore.instance
                  //     .collection('notification')
                  //     .doc(deleted.id)
                  //     .delete();
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
