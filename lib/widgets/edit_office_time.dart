import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  TimeOfDay ?startTime;
  TimeOfDay ?endTime;
  String ?time2;
  String officeHours = '';
  List<String> days = [];
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
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          leading: const BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Form(
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
                      padding:
                          const EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: SelectWeekDays(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        days: _days,
                        border: false,
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            colors: [Color(0xFFE55CE4), Color(0xFFBB75FB)],
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
                              TimeRange result = await showTimeRangePicker(
                                  context: context,
                                  start: const TimeOfDay(hour: 9, minute: 0),
                                  end: const TimeOfDay(hour: 12, minute: 0),
                                  disabledTime: TimeRange(
                                      startTime:
                                          const TimeOfDay(hour: 18, minute: 0),
                                      endTime:
                                          const TimeOfDay(hour: 6, minute: 0)),
                                  disabledColor: Colors.red.withOpacity(0.5),
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
                                  ].asMap().entries.map((e) {
                                    return ClockLabel.fromIndex(
                                        idx: e.key, length: 8, text: e.value);
                                  }).toList(),
                                  labelOffset: 35,
                                  rotateLabels: false,
                                  padding: 60);
                              setState(() {
                                startTime = result.startTime;
                                endTime = result.endTime;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
        // FutureBuilder<UserWorkingHours?>(
        //     future: readUser(),
        //     builder: (context, snapshot) {
        //       if(snapshot.hasData){
        //         final user = snapshot.data!;
        //         return Column(
        //           children: [
        //             Text(
        //               user.workingHours,
        //               style: GoogleFonts.lato(
        //                 fontSize: 17,
        //               ),
        //             ),
        //           ],
        //         );
        //       }
        //       else{
        //         return Center(child: Text('hello'),);
        //       }
        //     }
        // ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            onPressed: () {
                              updateOfficeTimeField(officeHours: ttt());
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        ));
  }
  String? getTime() {
    if (startTime == null && endTime == null) {
      return "Select Time";
    } else {
      time2 ="${startTime.toString().substring(10, 15)} - ${endTime.toString()
          .substring(10, 15)}";
      return time2;
    }
  }
   ttt(){
     Map map1 = {};
    if(time2 == null){
      print('please enter an office time');
      return 'error1';
    }else if(days.isEmpty){
      print('please select a day');
      return 'error2';
    }else {
      for (int i = 0; i < days.length; i++) {
        map1.addAll({days[i]: time2});
      }
      return map1;
    }
  }
  Future updateOfficeTimeField({required Map officeHours}) async{
    final docUser = FirebaseFirestore.instance.collection('officeHours').doc();
    final json = {
      'officeHours': officeHours,
      'id': currentUser.uid,
    };
    await docUser.update(json);
    // docUser.update({
    //   'officeHours.Sunday': 'thursday',
    //   'officeHours.Monday': '',
    //   'officeHours.Tuesday': '',
    //   'officeHours.Wednesday': '',
    //   'officeHours.Thursday': '',
    //   'officeHours.Friday': '',
    //   'officeHours.Saturday': '',
    // });
  }
  // Future<UserWorkingHours?> readUser() async {
  //   final getUser = FirebaseFirestore.instance
  //       .collection('Service')
  //       .where('id', isEqualTo: currentUser.uid);
  //   final json = {
  //     'officeHours': officeHours,
  //     'id': currentUser.uid,
  //   };
  //   final snapshot = await getUser.get();
  //     return UserWorkingHours.fromJson(json);
  // }
}
