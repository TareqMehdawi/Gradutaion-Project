import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/user_class.dart';
import 'package:time_range_picker/time_range_picker.dart';

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
  TimeOfDay? startTime;
  TimeOfDay? endTime;
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
  void initState() {
    // getNotifi();
    // readDoc();
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<UserAccount?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something ${snapshot.error}');
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return Form(
                  key: _formKey,
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                          width: 320,
                          child: Center(
                            child: Text(
                              "What's your Office Hours?",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 40, left: 20, right: 20),
                            child: SelectWeekDays(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              days: _days,
                              border: false,
                              boxDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  colors: [
                                    Color(0xFFE55CE4),
                                    Color(0xFFBB75FB)
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: 320,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      maximumSize: const Size.fromHeight(40),
                                      primary: Colors.black),
                                  child: FittedBox(
                                    child: Text(
                                      getTime()!,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    TimeRange result =
                                    await showTimeRangePicker(
                                        context: context,
                                        start: const TimeOfDay(
                                            hour: 9, minute: 0),
                                        end: const TimeOfDay(
                                            hour: 12, minute: 0),
                                        disabledTime: TimeRange(
                                            startTime: const TimeOfDay(
                                                hour: 18, minute: 0),
                                            endTime: const TimeOfDay(
                                                hour: 6, minute: 0)),
                                        disabledColor:
                                        Colors.red.withOpacity(0.5),
                                        strokeWidth: 4,
                                        ticks: 24,
                                        ticksOffset: -7,
                                        ticksLength: 15,
                                        ticksColor: Colors.grey,
                                        labels: [
                                          "12 am",
                                          "3 am",
                                          "6 am",
                                          "9 am",
                                          "12 pm",
                                          "3 pm",
                                          "6 pm",
                                          "9 pm"
                                        ]
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return ClockLabel.fromIndex(
                                              idx: e.key,
                                              length: 8,
                                              text: e.value);
                                        }).toList(),
                                        labelOffset: 35,
                                        rotateLabels: false,
                                        padding: 60);
                                    setState(() {
                                      startTime = result.startTime;
                                      endTime = result.endTime;
                                      officeHours = '${startTime
                                          .toString()
                                          .substring(10, 15)} - ${endTime.toString().substring(10, 15)}';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              for(var a in user.officeHours.keys.toList())
                                if(a.toString() == 'Sunday')
                                  buildDays(day: 'Sunday',
                                      value: user.officeHours['Sunday']),
                              for(var a in user.officeHours.keys.toList())
                                if(a.toString() == 'Monday')
                                  buildDays(day: 'Monday',
                                      value: user.officeHours['Monday']),
                              for(var a in user.officeHours.keys.toList())
                                if(a.toString() == 'Tuesday')
                                  buildDays(day: 'Tuesday',
                                      value: user.officeHours['Tuesday']),
                              for(var a in user.officeHours.keys.toList())
                                if(a.toString() == 'Wednesday')
                                  buildDays(day: 'Wednesday',
                                      value: user.officeHours['Wednesday']),
                              for(var a in user.officeHours.keys.toList())
                                if(a.toString() == 'Thursday')
                                  buildDays(day: 'Thursday',
                                      value: user.officeHours['Thursday']),
                              for(var a in user.officeHours.keys.toList())
                                if(a.toString() == 'Friday')
                                  buildDays(day: 'Friday',
                                      value: user.officeHours['Friday']),
                              for(var a in user.officeHours.keys.toList())
                                if(a.toString() == 'Saturday')
                                  buildDays(day: 'Saturday',
                                      value:user.officeHours['Saturday']),
                              // day.add(user.officeHours.keys.toList());
                              // hour.add(user.officeHours.values.toList());
                              //   Padding(
                              //     padding: const EdgeInsets.symmetric(horizontal: 50.0),
                              //     child: Row(
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         const Text('Sunday: ', style: TextStyle(fontSize: 18),),
                              //         const SizedBox(
                              //           width: 20,
                              //         ),
                              //         Text(user.officeHours['Thursday'], style: TextStyle(fontSize: 18),),
                              //       ],
                              //     ),
                              //   ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: 320,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                  ),
                                  onPressed: () {
                                    updateOfficeTimeField(
                                        officeHours: ttt(),
                                        day: days,
                                        time: officeHours);
                                  },
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ));
            } else {
              return const Center(
                child: Text('hi'),
              );
            }
          }),
    );
  }

  String? getTime() {
    if (startTime == null && endTime == null) {
      return "Select Time";
    } else {
      time2 =
      "${startTime.toString().substring(10, 15)} - ${endTime.toString()
          .substring(10, 15)}";
      return time2;
    }
  }

  ttt() {
    Map map1 = {};
    if (time2 == null) {
      return 'error1';
    } else if (days.isEmpty) {
      return 'error2';
    } else {
      for (int i = 0; i < days.length; i++) {
        map1.addAll({days[i]: time2});
      }
      return map1;
    }
  }

  Future updateOfficeTimeField({required Map officeHours,
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EditOfficeHoursFormPage()));
          },
          onDissmissCallback: (d){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EditOfficeHoursFormPage()));
          }
      ).show();
    } on FirebaseAuthException catch (error){
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
          onDissmissCallback: (d){
            return Navigator.of(context).popUntil((route) => route.isFirst);
          }
      ).show();
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
      child: ListTile(
          title : Text(day, style: const TextStyle(fontSize: 18),),
          trailing: Text(value, style: const TextStyle(fontSize: 18),),
        onLongPress: () {
          AwesomeDialog(
              autoDismiss: false,
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Warning',
              desc: 'Are you sure you want to delete this item!',
              btnOkText: "Delete",
              btnCancelText: 'Cancel',
              btnOkOnPress: () async{
                final docUser =
                FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
                await docUser.update({'officeHours.$day': FieldValue.delete()});
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EditOfficeHoursFormPage()));
              },
              btnCancelOnPress: (){
                Navigator.pop(context);
              },
              onDissmissCallback: (d){
                Navigator.pop(context);
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EditOfficeHoursFormPage()));
              }
          ).show();
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditOfficeHoursFormPage()));
          // setState(() {
          //   isSelected = !isSelected;
          // });
        },
      ),
    );
  }
}
