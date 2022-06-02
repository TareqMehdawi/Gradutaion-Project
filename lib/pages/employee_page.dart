import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/pages/make_service.dart';
import 'package:graduation_project/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../styles/colors.dart';
import '../widgets/edit_appointment.dart';
import '../widgets/local_notification_service.dart';
import '../widgets/user_class.dart';
import 'navigation_drawer.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key, void function}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  String day = 'Every Day';
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  var token;

  updateToken() async {
    try {
      await _fcm.getToken().then((currentToken) {
        setState(() {
          token = currentToken;
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
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }
      LocalNotificationService.display(message);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deleteCard();
    // String selectedService =
    //     Provider.of<ReservationInfo>(context).selectedService;
    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
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
            updateUserName(token: token);
            if (users.isEmpty) {
              return Center(
                child: Image.asset('assets/images/Schedule-bro.png'),
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

// child: ListTile(
//   leading:  Padding(
//     padding: const EdgeInsets.only(top: 10.0),
//     child: Text(user.date),
//   ),
//   title: Text(user.student),
//   subtitle:  Text(
//       'Service: ${user.service} \nExpected time: ${user.time}'),
//   trailing: const Icon(Icons.arrow_forward_ios),
//   contentPadding: const EdgeInsets.symmetric(
//       vertical: 15, horizontal: 15),
//   onTap: () {},
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(10.0),
//   ),
//   tileColor: Colors.grey.shade300,
// ),
// class ScheduleCard extends StatelessWidget {
//   const ScheduleCard({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     StudentsReservation user;
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(MyColors.bg01),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       width: double.infinity,
//       padding: EdgeInsets.all(20),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children:  [
//           Icon(
//             Icons.calendar_today,
//             color: Colors.white,
//             size: 15,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Text(
//             user.date,
//             style: TextStyle(color: Colors.white),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Icon(
//             Icons.access_alarm,
//             color: Colors.white,
//             size: 17,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Flexible(
//             child: Text(
//               '11:00 ~ 12:10',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
