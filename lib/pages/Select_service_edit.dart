import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/employee_services.dart';

import '../widgets/user_class.dart';

class DeleteSelectService extends StatefulWidget {
  String serviceName;
  String duration;
  Map days;
  String uid;
  final currentUser = FirebaseAuth.instance.currentUser!;

  DeleteSelectService(
      {Key? key,
      required this.serviceName,
      required this.days,
      required this.duration,
      required this.uid})
      : super(key: key);

  @override
  State<DeleteSelectService> createState() => _DeleteSelectService();
}

class _DeleteSelectService extends State<DeleteSelectService> {
  final formKey = GlobalKey<FormState>();
  int currentStep = 0;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? duration;
  bool newDay=false;
  bool newTime=false;
  //List<Message> messages = [];
  List newDays = [];
  final currentUser = FirebaseAuth.instance.currentUser!;

  String? selectedValue;
  List<String> items = [
    '5 minute',
    '10 minute',
    '15 minute',
    '20 minute',
    '25 minute',
    '30 minute',
  ];

  List<DayInWeek> daysSelected() {
    final List<DayInWeek> days = [
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
    for (int i = 0; i < days.length; i++) {
      for (int j = 0; j < widget.days.length; j++) {
        if (days[i].dayName == widget.days[j]) {
          days[i].isSelected = true;
          break;
        }
      }
    }

    return days;
  }

  List<DayInWeek> officeHoursDays(UserAccount? user) {
    final List<DayInWeek> days = [];
    List day = [];
    day.addAll(user!.officeHours.keys);
    for (int i = 0; i < day.length; i++) {
      days.add(DayInWeek(day[i].toString()));
    }

    return days;
  }

  String? time2;

  @override
  Widget build(BuildContext context) {
    TextEditingController serviceController =
        TextEditingController(text: widget.serviceName);
    // String selectedService =
    //     Provider.of<ReservationInfo>(context).selectedService;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff205375),
        title: const Text('Edit Service'),
        centerTitle: true,
      ),
      body: FutureBuilder<UserAccount?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;
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
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Image(
                        image: AssetImage('assets/images/editService.png'),
                        height: 250,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: serviceController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 20, top: 20, bottom: 20),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90.0)),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[350],
                              hintStyle: GoogleFonts.lato(
                                color: Colors.black26,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                              suffixIcon: Icon(Icons.design_services,
                                  color: Color(0xff205375)),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (serviceController.text.isEmpty) {
                                return 'Please enter a service name.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        child: SelectWeekDays(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          days: officeHoursDays(user),
                          border: false,
                          boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
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
                            newDays = [];
                            newDays.addAll(values);
                            newDay=true;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 16,
                                  color: Color(0xff205375),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.duration,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff205375),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: items
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value as String;
                                duration = value;
                                newTime=true;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor: Color(0xff205375),
                            iconDisabledColor: Colors.white,
                            buttonHeight: 50,
                            buttonWidth: 500,
                            buttonPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: Colors.grey.shade400,
                            ),
                            buttonElevation: 2,
                            itemHeight: 40,
                            itemPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            dropdownMaxHeight: 200,
                            dropdownPadding: null,
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.grey.shade400,
                            ),
                            dropdownElevation: 8,
                            scrollbarRadius: const Radius.circular(40),
                            scrollbarThickness: 6,
                            scrollbarAlwaysShow: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, top: 0, bottom: 0, right: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            child: Text(
                              "Update",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              final isValid = formKey.currentState!.validate();
                              if (isValid && newDay==true && newTime==true) {
                                try {
                                  updateServiceName(
                                      serviceName: serviceController.text);
                                  //updateTime(time: time2!);
                                  updateDuration(duration: duration!);
                                  updateDays(
                                      user: user!.officeHours, days: newDays);
                                  AwesomeDialog(
                                    autoDismiss: false,
                                    context: context,
                                    dialogType: DialogType.SUCCES,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Success',
                                    desc: 'Service updated successfully',
                                    btnOkText: "Go back",
                                    btnCancelColor: Colors.black87,
                                    btnOkOnPress: () {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyServices()));
                                    },
                                    onDissmissCallback: (d) {
                                      Navigator.pop(context);
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
                              }else{

                              AwesomeDialog(
                              autoDismiss: false,
                              context: context,
                              dialogType: DialogType.WARNING,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Warning',
                              desc: 'Please fill all fields',
                              btnOkText: "Ok",
                              btnCancelColor: Colors.black87,
                              btnOkOnPress: () {
                              Navigator.pop(context);
                              },
                              onDissmissCallback: (d) {

                              },
                              ).show();


                              }



                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: Color(0xff205375),
                              onPrimary: Color(0xff205375),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Text('data');
            }
          }),
    );
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

  Future updateDays({required List days, required Map user}) async {
    Map newdays = {};

    for (var day in user.keys) {
      for (int i = 0; i < days.length; i++) {
        if (day == days[i]) {
          newdays = {days[i]: user[day]};
        }
      }
    }

    final docUser2 = await FirebaseFirestore.instance
        .collection('Service')
        .where('service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service')
          .doc(doc.id)
          .update({'days': newdays});
    }
  }

  Future updateServiceName({required String serviceName}) async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('Service')
        .where('service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service')
          .doc(doc.id)
          .update({'service': serviceName});
    }
  }

  Future updateDuration({required String duration}) async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service')
          .doc(doc.id)
          .update({'duration': duration});
    }
  }

  Future deleteService() async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('Service')
        .where('service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service')
          .doc(doc.id)
          .delete();
    }
  }
}
