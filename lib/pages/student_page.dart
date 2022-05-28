import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../styles/colors.dart';
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
  // DateTime time = DateTime.now();
  // String? format;
  // List arr = [];
  @override
  Widget build(BuildContext context) {
    // format = DateFormat.jm().format(time).trim();
    // arr.add(format?.split(
    //   ': ',
    // ));
    // print(arr);
//    String selectedService = Provider.of<ReservationInfo>(context).selectedService;
    //String name = selectedService;
    return Scaffold(
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
                              )),
                      Center(
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .22),
                            child: const Text(
                              "Student page",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
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
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  children: users.map(buildListTile).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Loading"),
              );
            } else {
              return const Center(
                child: Text("Loading"),
              );
            }
          }),
    );
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
                              backgroundImage: NetworkImage(user.image),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                width: 80,
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

  Stream<List<StudentsReservation>> readReservation() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('reservation')
        .where("id", isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentsReservation.fromJson(doc.data()))
            .toList());
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
