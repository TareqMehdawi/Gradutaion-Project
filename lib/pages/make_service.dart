import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';

import '../widgets/user_class.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  TextEditingController serviceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int currentStep = 0;
  DateTime? date;
  String? startTime;
  String? endTime;
  String? duration;
  TimeOfDay time = TimeOfDay.now();

  //List<Message> messages = [];
  List<String> days = [];
  final currentUser = FirebaseAuth.instance.currentUser!;

  //String dropdownvalue = 'Item 1';
  String? time2;

  // String? getStartTime() {
  //   if (startTime == null) {
  //     return "Select Time";
  //   } else {
  //     return startTime.toString().substring(10, 15);
  //   }
  // }

  String? selectedValue;
  List<String> items = [
    '5 minute',
    '10 minute',
    '15 minute',
    '20 minute',
    '25 minute',
    '30 minute',
  ];

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
    serviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff205375),
        title: const Text('Add Service'),
        leading: const BackButton(),
        centerTitle: true,
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: TextFormField(
                controller: serviceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your new service',
                  labelText: 'Service',
                  suffixIcon: Icon(
                    Icons.design_services_rounded,
                  ),
                ),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                  tileMode:
                      TileMode.repeated, // repeats the gradient over the canvas
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 320,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              maximumSize: const Size.fromHeight(40),
                              primary: Colors.black),
                          child: FittedBox(
                            child: Text(
                              startTime == null
                                  ? "Select Start Time"
                                  : "$startTime",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext builder) {
                                  return Container(
                                    height: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .height *
                                        0.25,
                                    color: Colors.white,
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.time,
                                      onDateTimeChanged: (value) {
                                        setState(() {
                                          if (value != startTime) {
                                            startTime =
                                                '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}';
                                          }
                                          int t = value.hour;
                                          if (t > 12) {
                                            t = t - 12;
                                            startTime =
                                                '${t.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}';
                                          }
                                        });
                                      },
                                      initialDateTime: DateTime.now(),
                                    ),
                                  );
                                });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              maximumSize: const Size.fromHeight(40),
                              primary: Colors.black),
                          child: FittedBox(
                            child: Text(
                              endTime == null ? "Select End Time" : "$endTime",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext builder) {
                                  return Container(
                                    height: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .height *
                                        0.25,
                                    color: Colors.white,
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.time,
                                      onDateTimeChanged: (value) {
                                        setState(() {
                                          if (value != endTime) {
                                            endTime =
                                                '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}';
                                          }
                                          int t = value.hour;
                                          if (t > 12) {
                                            t = t - 12;
                                            endTime =
                                                '${t.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}';
                                          }
                                        });
                                      },
                                      initialDateTime: DateTime.now(),
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    children: const [
                      Icon(
                        Icons.list,
                        size: 16,
                        color: Colors.yellow,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'Select Time',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
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
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.yellow,
                  iconDisabledColor: Colors.grey,
                  buttonHeight: 50,
                  buttonWidth: 160,
                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.redAccent,
                  ),
                  buttonElevation: 2,
                  itemHeight: 40,
                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                  dropdownMaxHeight: 200,
                  dropdownWidth: 200,
                  dropdownPadding: null,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.redAccent,
                  ),
                  dropdownElevation: 8,
                  scrollbarRadius: const Radius.circular(40),
                  scrollbarThickness: 6,
                  scrollbarAlwaysShow: true,
                  offset: const Offset(-20, 0),
                ),
              ),
            ),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if (isValid) {
                      setService(
                        Duration: duration!,
                        Service: serviceController.text,
                        Time: "$startTime - $endTime",
                        days: days,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future setService({
    String? id,
    required String Duration,
    required String Service,
    required String Time,
    required List<String> days,
  }) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('Service').doc();
      final user = SetEmpService(
        id: currentUser.uid,
        Service: Service,
        days: days,
        Duration: Duration,
        Time: Time,
      );
      final json = user.toJson();
      await docUser.set(json);
      AwesomeDialog(
        autoDismiss: false,
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Success',
        desc: 'Service added successfully',
        btnOkText: "Add more services",
        btnCancelText: 'Go back',
        btnCancelColor: Colors.black87,
        btnOkOnPress: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ServicePage()));
        },
        onDissmissCallback: (d) {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ServicePage()));
        },
        btnCancelOnPress: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationDrawer()));
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
                  builder: (context) => const NavigationDrawer()));
        },
        btnCancelOnPress: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationDrawer()));
        },
      ).show();
    }
  }
}
