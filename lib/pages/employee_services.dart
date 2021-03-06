import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/Select_service_edit.dart';

import '../styles/colors.dart';
import '../widgets/user_class.dart';
import 'make_service.dart';

class MyServices extends StatefulWidget {
  const MyServices({Key? key, void function}) : super(key: key);

  @override
  State<MyServices> createState() => _MyServices();
}

class _MyServices extends State<MyServices> {
  @override
  Widget build(BuildContext context) {
    // String selectedService =
    //     Provider.of<ReservationInfo>(context).selectedService;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff205375),
        title: const Text('My Services'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SetEmpService>>(
        stream: reviewService(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            if(users.isEmpty){
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.1),
                    child: Image.asset('assets/images/Empty-bro.png'),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Column(
                          children: [
                            Text(
                              "You didn't add any service!",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff205375),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width * 0.9,
                                    height: 70,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 15.0),
                                      child: ElevatedButton(
                                        child: Text(
                                          "Add Service",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ServicePage()));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 2,
                                          primary: Color(0xff205375),
                                          onPrimary: Color(0xff205375),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(14.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Loading1"),
            );
          } else {
            return const Center(
              child: Text("Loading"),
            );
          }
        },
      ),
    );
  }

  Future deleteService(SetEmpService user) async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('Service')
        .where('service', isEqualTo: user.service)
        .where('id', isEqualTo: user.id)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service')
          .doc(doc.id)
          .delete();
    }
  }

  Stream<List<SetEmpService>> reviewService() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('Service')
        .where("id", isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SetEmpService.fromJson(doc.data()))
            .toList());
  }

  String days(Map map) {
    String day = "";
    for (var m in map.keys) {
      if (map.keys.length > 1) {
        if (m == map.keys.last) {
          day = day + "$m";
          break;
        }
        day = day + "$m\n";
      } else
        day = day + "$m";
    }

    return day;
  }

  Widget buildListTile(SetEmpService user) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.service,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(MyColors.bg03),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            days(user.days),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_alarm,
                            color: Colors.black,
                            size: 17,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            user.duration,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        child: Text('Delete'),
                        onPressed: () async {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Warning',
                            desc:
                                'Are you sure you want to delete this service',
                            btnOkText: "Delete",
                            btnCancelText: 'Cancel',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              try {
                                deleteService(user);
                                AwesomeDialog(
                                  autoDismiss: false,
                                  context: context,
                                  dialogType: DialogType.SUCCES,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Success',
                                  desc: 'Service deleted successfully',
                                  btnOkText: 'Ok',
                                  btnCancelColor: Colors.black87,
                                  onDissmissCallback: (d) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyServices()));
                                  },
                                  btnOkOnPress: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyServices()));
                                  },
                                ).show();
                              } on FirebaseAuthException catch (error) {
                                AwesomeDialog(
                                  autoDismiss: false,
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Error',
                                  desc: '${error.message}',
                                  btnCancelText: 'Go back',
                                  btnCancelColor: Colors.black87,
                                  onDissmissCallback: (d) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyServices()));
                                  },
                                  btnCancelOnPress: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyServices()));
                                  },
                                ).show();
                              }
                            },
                          ).show();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Reschedule'),
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteSelectService(
                                serviceName: user.service,
                                days: user.days,
                                duration: user.duration,
                                uid: user.id,
                              ),
                            ),
                          )
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
