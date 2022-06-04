import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/pages/make_service.dart';
import 'package:graduation_project/widgets/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/colors.dart';
import '../widgets/edit_appointment.dart';
import '../widgets/local_notification_service.dart';
import '../widgets/user_class.dart';
import 'navigation_drawer.dart';

class EmployeePage extends StatefulWidget {
  final type;
  const EmployeePage({Key? key, void function, required this.type})
      : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  String day = 'Every Day';
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  var token = 'dv';
  String? stdToken;

  updateToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var notification = preferences.getString("NOTIFICATION");
    if (notification == "true") {
      await _fcm.getToken().then((currentToken) {
        setState(() {
          token = currentToken!;
        });
        setToken(token: token);
      });
    } else {
      setState(() {
        token = "null";
      });
      setToken(token: token);
    }
  }

  Future setToken({required String token}) async {
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

  Future deleteCard() async {
    var date = DateTime.now();
    var hourMinute = DateFormat("HH:mm").format(date);
    final day = DateFormat('EEEE').format(date);
    final docUser2 = await FirebaseFirestore.instance
        .collection('reservation')
        .where('date', isEqualTo: day.toString())
        .where('empId', isEqualTo: currentUser.uid)
        .get();
    for (var doc in docUser2.docs) {
      String time = doc.data()['time'].toString().substring(8, 13);

      if (((int.parse(time.substring(3, 5)) ==
                  int.parse(hourMinute.toString().substring(3, 5)) &&
              int.parse(time.substring(0, 2)) ==
                  int.parse(hourMinute.toString().substring(0, 2))) ||
          int.parse(time.substring(0, 2)) <
              int.parse(hourMinute.toString().substring(0, 2)))) {
        await FirebaseFirestore.instance
            .collection('reservation')
            .doc(doc.id)
            .delete();
      }
    }
    return null;
  }

  @override
  void initState() {
    updateToken();

    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {}
      LocalNotificationService.display(message);
    });

    super.initState();
    deleteCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Employee Page",
          filterFunction: () {
            buildBottomSheet();
          },
          menuFunction: () {
            setState(() {
              Provider.of<NavigationProvider>(context, listen: false)
                  .changeValue();
            });
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff205375),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ServicePage(),
            ),
          );
        },
      ),
      body: StreamBuilder<List<StudentsReservation>>(
        stream: readReservation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            if (users.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Schedule-bro.png'),
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
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return splashScreen();
          } else {
            return const Center(
              child: Text("Error"),
            );
          }
        },
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
                    loginButton(
                      title: 'Sunday',
                    ),
                    loginButton(
                      title: 'Monday',
                    ),
                    loginButton(
                      title: 'Tuesday',
                    ),
                    loginButton(
                      title: 'Wednesday',
                    ),
                    loginButton(
                      title: 'Thursday',
                    ),
                    loginButton(
                      title: 'Friday',
                    ),
                    loginButton(
                      title: 'Saturday',
                    ),
                    loginButton(
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

  Widget loginButton({required String title}) {
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

  Future getStdToken(StudentsReservation user) async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: user.empId)
        .get();
    for (var doc in docUser2.docs) {
      stdToken = doc.data()['token'];
    }
    return stdToken;
  }

  Stream<List<StudentsReservation>> readReservation() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    if (day == 'Every Day') {
      var ref2 = FirebaseFirestore.instance
          .collection('reservation')
          .where("empId", isEqualTo: currentUser.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => StudentsReservation.fromJson(doc.data()))
              .toList());

      return ref2;
    } else {
      var ref = FirebaseFirestore.instance
          .collection('reservation')
          .where("empId", isEqualTo: currentUser.uid)
          .where("date", isEqualTo: day.trim())
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => StudentsReservation.fromJson(doc.data()))
              .toList());

      return ref;
    }
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
                                  backgroundImage: NetworkImage(user.image),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.student,
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
                              onPressed: () async {
                                await getStdToken(user);
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
                                      token: '',
                                      stdName: user.student,
                                      type: widget.type,
                                      empName: user.empName,
                                    ),
                                  ),
                                );
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
                                    user.date,
                                    style: TextStyle(color: Colors.black),
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
                                    user.time,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
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
                color: Color(MyColors.bg02),
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
}
