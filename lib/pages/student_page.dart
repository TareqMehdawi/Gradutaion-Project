import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/widgets/custom_appbar.dart';
import 'package:graduation_project/widgets/local_notification_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../styles/colors.dart';
import '../widgets/edit_appointment.dart';
import '../widgets/search_delegate_employee.dart';
import '../widgets/user_class.dart';
import 'navigation_drawer.dart';

class StudentPage extends StatefulWidget {
  final String stdName;
  final String stdImage;
  const StudentPage(
      {Key? key, void function, required this.stdName, required this.stdImage})
      : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  String day = 'Every Day';

  final currentUser = FirebaseAuth.instance.currentUser!;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  var token;
  String receivedPushMessage = '';

  void listenForMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        setState(() {
          String? body = message.notification?.body;
          if (body != null) {
            this.receivedPushMessage = body;
          } else {
            this.receivedPushMessage = "message boy was null";
          }
        });
      }
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAc7t946A:APA91bFfNHbG4zCoFxqgR8-i3UnX0E1SkSGJZ_iW5k6YSI-uIGpVYMqP4lgw9j45xVDXX1KnGDvW9gSejPu-tHdQFP_I11FlH_qYTrs24X3sBR7pLcbUGwPt8Qres-IoFHWCw8VuFwjw',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  @override
  void initState() {
    updateToken();
    listenForMessages();

    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }
      LocalNotificationService.display(message);
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Student Page',
          filterFunction: () {
            buildBottomSheet2();
          },
          menuFunction: () {
            // sendPushMessage(
            //     'cbSymk6TS4y28q_OjfU1Nn:APA91bHFQ30eB-KIYDzCIxl1Cw1U3HmiaezitixHSgdGwl_a81Xd3wWkBt-1N0uvRbJDF1UlbtIAdJ85WrczPRrs8sb2irdJnQG9IJd_2zp24soEAzBIHgE6twUelfCmg4fSqCBNoaah',
            //     'body ',
            //     'title');
            setState(() {
              Provider.of<NavigationProvider>(context, listen: false)
                  .changeValue();
            });
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff205375),
        child: const Icon(Icons.add),
        onPressed: () async {
          buildBottomSheet();
          // await showSearch(
          //     context: context,
          //     delegate: EmployeeSearchDelegate(),
          // );
        },
      ),
      body: StreamBuilder<List<StudentsReservation>>(
        stream: readReservation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            updateUserName(token: token);

            if (users.isEmpty) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.1),
                    child: Image.asset('assets/images/Schedule-bro.png'),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Column(
                          children: [
                            Text(
                              "You have no meetings for today",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff205375),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add one",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color(0xff205375),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_sharp,
                                  color: Color(0xff205375),
                                  size: 35,
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
            } else {
              return Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Image.asset(
                          "assets/images/bottom_left.png",
                          width: MediaQuery.of(context).size.width * .3,
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(12.0),
                    children: [...users.map(buildListTile).toList()],
                  ),
                ],
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("hi"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: 200.0,
              height: 100.0,
              child: CircularProgressIndicator(),
              // Shimmer.fromColors(
              //   baseColor: Colors.red,
              //   highlightColor: Colors.yellow,
              //   child: const Text(
              //     'Shimmer',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 40.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            );
          } else {
            return const Center(
              child: Text("Error"),
            );
          }
        },
      ),
    );
  }

  Widget buildListTile(StudentsReservation user) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff205375),
                    Color(0xff92B4EC),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  //onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(user.imageemp),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.empName,
                                        style: TextStyle(color: Colors.white)),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      user.service,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.edit_sharp, color: Colors.white),
                              onPressed: () {
                                //Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EditScreen(
                                              student_id: user.id,
                                              emp_id: user.empId,
                                              service: user.service,
                                              time: user.time,
                                              duration: user.duration,
                                              officeHour: user.officehour,
                                              day: user.date,
                                            )));
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffEEEEEE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                user.date,
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 85,
                              ),
                              Icon(
                                Icons.access_alarm,
                                color: Colors.black,
                                size: 17,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  user.time,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                color: Color(0xff92B4EC),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                color: Color(MyColors.bg03),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );

  // Stream<List<StudentsReservation>> readReservation() {
  //   final currentUser = FirebaseAuth.instance.currentUser!;
  //   return FirebaseFirestore.instance
  //       .collection('reservation')
  //       .where("id", isEqualTo: currentUser.uid)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => StudentsReservation.fromJson(doc.data()))
  //           .toList());
  // }
  Stream<List<StudentsReservation>> readReservation() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    if (day == 'Every Day') {
      var ref2 = FirebaseFirestore.instance
          .collection('reservation')
          .where("id", isEqualTo: currentUser.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => StudentsReservation.fromJson(doc.data()))
              .toList());

      return ref2;
    } else {
      var ref = FirebaseFirestore.instance
          .collection('reservation')
          .where("id", isEqualTo: currentUser.uid)
          .where("date", isEqualTo: day.trim())
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => StudentsReservation.fromJson(doc.data()))
              .toList());

      return ref;
    }
  }

  Future buildBottomSheet2() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => SizedBox(
        height: 320,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
          child: ListView(
            children: [
              const Center(
                child: Text(
                  "Choose what day you want to filter:",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Wrap(
                  spacing: 15,
                  runSpacing: 16,
                  children: [
                    loginButton2(
                      title: 'Sunday',
                    ),
                    loginButton2(
                      title: 'Monday',
                    ),
                    loginButton2(
                      title: 'Tuesday',
                    ),
                    loginButton2(
                      title: 'Wednesday',
                    ),
                    loginButton2(
                      title: 'Thursday',
                    ),
                    loginButton2(
                      title: 'Friday',
                    ),
                    loginButton2(
                      title: 'Saturday',
                    ),
                    loginButton2(
                      title: 'Every Day',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateToken() async {
    try {
      await _fcm.getToken().then((currentToken) {
        setState(() {
          token = currentToken;

          print(token);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateUserName({required String token}) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      final json = {
        'token': token,
      };
      await docUser.update(json);
    } catch (e) {
      print(e);
    }
  }

  Widget loginButton2({required String title}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * .20,
            MediaQuery.of(context).size.height * .06),
        side: const BorderSide(width: 1, color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: () {
        setState(() {
          day = title;
        });
        Navigator.pop(context);
      },
      child: Text(
        title,
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Future buildBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
          child: ListView(
            children: [
              const Center(
                child: Text(
                  "Choose who you want to meet:",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  loginButton(
                    title: 'Doctor',
                    function: () async {
                      Navigator.pop(context);
                      await showSearch(
                        context: context,
                        delegate: EmployeeSearchDelegate(
                            type: 'doctor',
                            stdName: widget.stdName,
                            stdImage: widget.stdImage),
                      );
                    },
                  ),
                  loginButton(
                    title: 'Registration',
                    function: () async {
                      Navigator.pop(context);
                      await showSearch(
                        context: context,
                        delegate: EmployeeSearchDelegate(
                            type: 'registration',
                            stdName: widget.stdName,
                            stdImage: widget.stdImage),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton({required String title, required VoidCallback function}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * .35,
            MediaQuery.of(context).size.height * .06),
        side: const BorderSide(width: 1, color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: function,
      child: Text(
        title,
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Future deleteService(StudentsReservation user) async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('reservation')
        .where('empId', isEqualTo: user.empId)
        .where('id', isEqualTo: user.id)
        .where('service', isEqualTo: user.service)
        .where('time', isEqualTo: user.time)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('reservation')
          .doc(doc.id)
          .delete();
    }
  }
  // for (var doc in docUser2.docs) {
  //   await FirebaseFirestore.instance
  //       .collection('reservation')
  //       .doc(doc.id)
  //       .delete();
  // }
}
