import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/make_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../styles/colors.dart';
import '../widgets/user_class.dart';
import 'navigation_drawer.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key, void function}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  String day = 'Every Day';

  @override
  Widget build(BuildContext context) {
    // String selectedService =
    //     Provider.of<ReservationInfo>(context).selectedService;

    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(300, 300),
        child: Container(
          //color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Container(
            height: 80,
            child: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  RotatedBox(
                      quarterTurns: 2,
                      child: WaveWidget(
                        config: CustomConfig(
                          colors: [const Color(0xff205375)],
                          durations: [22000],
                          heightPercentages: [-0.1],
                        ),
                        size: const Size(double.infinity, double.infinity),
                        waveAmplitude: 1,
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          onPressed: () {
                            setState(() {
                              Provider.of<NavigationProvider>(context,
                                      listen: false)
                                  .changeValue();
                            });
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * .22),
                          child: const Text(
                            "Employee page",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .18),
                        child: IconButton(
                          onPressed: () {
                            buildBottomSheet();
                          },
                          icon: const Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
          List? t = snapshot.data;
          List s = [];
          s.add(t);
          if (s.isEmpty) {
            return Center(
              child: Image.asset('assets/images/Schedule-bro.png'),
            );
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(12.0),
              children: [...users.map(buildListTile).toList()],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Loading1"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: 200.0,
              height: 100.0,
              child: Shimmer.fromColors(
                baseColor: Colors.red,
                highlightColor: Colors.yellow,
                child: const Text(
                  'Shimmer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
        Navigator.pop(context);
        setState(() {
          day = title;
        });
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
      return FirebaseFirestore.instance
          .collection('reservation')
          .where("empId", isEqualTo: currentUser.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => StudentsReservation.fromJson(doc.data()))
              .toList());
    } else {
      var ref = FirebaseFirestore.instance
          .collection('reservation')
          .where("empId", isEqualTo: currentUser.uid)
          .where("date", isEqualTo: day)
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
                color: const Color(0xff398AB9),
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
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(user.image),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                width: 100,
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
