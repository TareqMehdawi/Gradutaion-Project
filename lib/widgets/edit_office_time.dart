import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/widgets/backbutton_widget.dart';
import 'package:graduation_project/widgets/user_class.dart';
import 'package:intl/intl.dart';

import '../styles/colors.dart';

class EditOfficeHoursFormPage extends StatefulWidget {
  const EditOfficeHoursFormPage({Key? key}) : super(key: key);

  @override
  EditOfficeHoursFormPageState createState() {
    return EditOfficeHoursFormPageState();
  }
}

class EditOfficeHoursFormPageState extends State<EditOfficeHoursFormPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  String? startTime;
  String? endTime;
  String? time2;
  String officeHours = '';
  List<String> days = [];
  List<String> time = [];
  List day = [];
  List hour = [];
  bool isSelected = false;

  final List<DayInWeek> _days = [
    DayInWeek(
      "Sunday",
    ),
    DayInWeek(
      "Monday",
    ),
    DayInWeek(
      "Tuesday",
    ),
    DayInWeek(
      "Wednesday",
    ),
    DayInWeek(
      "Thursday",
    ),
    DayInWeek(
      "Friday",
    ),
    DayInWeek(
      "Saturday",
    ),
  ];

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<UserAccount?>(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                final user = snapshot.data!;
                return Form(
                    key: _formKey,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: customBackButton(color: Color(0xff205375)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                "assets/images/top_right.png",
                                width: MediaQuery.of(context).size.width * .3,
                              ),
                            ),
                          ],
                        ),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 320,
                                  child: Center(
                                    child: Text(
                                      "What's your Office Hours?",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff205375)),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 40, left: 20, right: 20),
                                      child: SelectWeekDays(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        days: _days,
                                        border: false,
                                        boxDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            colors: [
                                              Color(0xff205375),
                                              Color(0xff92B4EC),
                                            ],
                                            tileMode: TileMode
                                                .repeated, // repeats the gradient over the canvas
                                          ),
                                        ),
                                        onSelect: (values) {
                                          // <== Callback to handle the selected days
                                          days = [];
                                          days.addAll(values);
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          child: SizedBox(
                                            width: 195,
                                            child: Center(
                                              child: editOfficeTimeButton(
                                                  function: () async {
                                                    TimeOfDay? pickedTime =
                                                        await showTimePicker(
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                      context: context,
                                                    );
                                                    DateTime parsedTime =
                                                        DateTime(
                                                            0,
                                                            0,
                                                            0,
                                                            pickedTime!.hour,
                                                            pickedTime.minute);
                                                    String starttime =
                                                        DateFormat('HH:mm')
                                                            .format(parsedTime);

                                                    setState(
                                                      () {
                                                        startTime = starttime;
                                                        // endTime = result.endTime;
                                                        // officeHours =
                                                        //     '${startTime.toString().substring(10, 15)} - ${endTime.toString().substring(10, 15)}';
                                                      },
                                                    );
                                                  },
                                                  name: getStartTime()!,
                                                  buttonColor:
                                                      Colors.grey.shade400,
                                                  textColor: Color(0xff205375)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: SizedBox(
                                            width: 195,
                                            child: Center(
                                              child: editOfficeTimeButton(
                                                  function: () async {
                                                    TimeOfDay? pickedTime =
                                                        await showTimePicker(
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                      context: context,
                                                    );
                                                    DateTime parsedTime =
                                                        DateTime(
                                                            0,
                                                            0,
                                                            0,
                                                            pickedTime!.hour,
                                                            pickedTime.minute);
                                                    String endtime =
                                                        DateFormat('HH:mm')
                                                            .format(parsedTime);

                                                    setState(
                                                      () {
                                                        endTime = endtime;
                                                        // endTime = result.endTime;
                                                        // officeHours =
                                                        //     '${startTime.toString().substring(10, 15)} - ${endTime.toString().substring(10, 15)}';
                                                      },
                                                    );
                                                  },
                                                  name: getEndTime()!,
                                                  buttonColor:
                                                      Colors.grey.shade400,
                                                  textColor: Color(0xff205375)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: editOfficeTimeButton(
                                                function: () {
                                                  officeHours =
                                                      "${startTime} - ${endTime}";
                                                  updateOfficeTimeField(
                                                      officeHours: ttt(),
                                                      day: days,
                                                      time: officeHours);
                                                },
                                                name: 'Update',
                                                buttonColor: Color(0xff205375),
                                                textColor: Colors.white)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        for (var a
                                            in user.officeHours.keys.toList())
                                          if (a.toString() == 'Sunday')
                                            buildDays(
                                                day: 'Sunday',
                                                value:
                                                    user.officeHours['Sunday']),
                                        for (var a
                                            in user.officeHours.keys.toList())
                                          if (a.toString() == 'Monday')
                                            buildDays(
                                                day: 'Monday',
                                                value:
                                                    user.officeHours['Monday']),
                                        for (var a
                                            in user.officeHours.keys.toList())
                                          if (a.toString() == 'Tuesday')
                                            buildDays(
                                                day: 'Tuesday',
                                                value: user
                                                    .officeHours['Tuesday']),
                                        for (var a
                                            in user.officeHours.keys.toList())
                                          if (a.toString() == 'Wednesday')
                                            buildDays(
                                                day: 'Wednesday',
                                                value: user
                                                    .officeHours['Wednesday']),
                                        for (var a
                                            in user.officeHours.keys.toList())
                                          if (a.toString() == 'Thursday')
                                            buildDays(
                                                day: 'Thursday',
                                                value: user
                                                    .officeHours['Thursday']),
                                        for (var a
                                            in user.officeHours.keys.toList())
                                          if (a.toString() == 'Friday')
                                            buildDays(
                                                day: 'Friday',
                                                value:
                                                    user.officeHours['Friday']),
                                        for (var a
                                            in user.officeHours.keys.toList())
                                          if (a.toString() == 'Saturday')
                                            buildDays(
                                                day: 'Saturday',
                                                value: user
                                                    .officeHours['Saturday']),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
              } else {
                return const Center(
                  child: Text('hi'),
                );
              }
            }));
  }

  String? getStartTime() {
    if (startTime == null) {
      return "Select Start Time";
    } else {
      return startTime;
    }
  }

  String? getEndTime() {
    if (endTime == null) {
      return "Select End Time";
    } else {
      return endTime;
    }
  }

  ttt() {
    Map map1 = {};
    if (officeHours == null) {
      return 'error1';
    } else if (days.isEmpty) {
      return 'error2';
    } else {
      for (int i = 0; i < days.length; i++) {
        map1.addAll({days[i]: officeHours});
      }
      return map1;
    }
  }

  Future updateOfficeTimeField(
      {required Map officeHours,
      required List<String> day,
      required String time}) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      for (int i = 0; i < day.length; i++) {
        String a = day[i];
        await docUser.update({'officeHours.$a': time});
      }
      AwesomeDialog(
          autoDismiss: false,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Success',
          desc: 'Office Hours Updated successfully',
          btnOkText: "Ok",
          btnOkOnPress: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditOfficeHoursFormPage()));
          },
          onDissmissCallback: (d) {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditOfficeHoursFormPage()));
          }).show();
    } on FirebaseAuthException catch (error) {
      AwesomeDialog(
          autoDismiss: false,
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error',
          desc: '${error.message}',
          btnOkText: "Ok",
          btnOkOnPress: () {
            return Navigator.of(context).popUntil((route) => route.isFirst);
          },
          onDissmissCallback: (d) {
            return Navigator.of(context).popUntil((route) => route.isFirst);
          }).show();
    }
  }

  Future<UserAccount?> readUser() async {
    final getUser =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final snapshot = await getUser.get();
    if (snapshot.exists) {
      return UserAccount.fromJson(snapshot.data()!);
    }
    return null;
  }

  Widget buildDays({required String day, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(MyColors.grey01),
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
                          color: Color(MyColors.header01),
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(MyColors.header01),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_alarm,
                          color: Color(MyColors.header01),
                          size: 17,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(MyColors.header01),
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
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Color(MyColors.header01)),
                      ),
                      onPressed: () async {
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
                            try {
                              await deleteOfficeHours(day);
                              await AwesomeDialog(
                                autoDismiss: false,
                                context: context,
                                dialogType: DialogType.SUCCES,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Success',
                                desc: 'Service deleted successfully',
                                btnOkText: 'Go back',
                                btnCancelColor: Colors.black87,
                                onDissmissCallback: (d) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EditOfficeHoursFormPage()));
                                },
                                btnOkOnPress: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EditOfficeHoursFormPage()));
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
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                                btnCancelOnPress: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                              ).show();
                            }
                          },
                        ).show();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget editOfficeTimeButton({
    required VoidCallback function,
    required String name,
    required Color buttonColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          //focusNode: f3,
          child: Text(
            name,
            style: GoogleFonts.lato(
              color: textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: function,
          style: ElevatedButton.styleFrom(
            elevation: 2,
            primary: buttonColor,
            onPrimary: Color(0xff205375),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      ),
    );
  }

  Future deleteOfficeHours(String day) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    await docUser.update({'officeHours.$day': FieldValue.delete()});
  }
}
