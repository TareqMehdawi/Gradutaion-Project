import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/employee_services.dart';
import 'package:time_range_picker/time_range_picker.dart';


class DeleteSelectService extends StatefulWidget {
  String time;
  String serviceName;
  String duration;
  List<dynamic> days;
  String uid;
  final currentUser = FirebaseAuth.instance.currentUser!;

  DeleteSelectService(
      {Key? key,
      required this.serviceName,
      required this.days,
      required this.time,
      required this.duration,
      required this.uid})
      : super(key: key);

  @override
  State<DeleteSelectService> createState() => _DeleteSelectService();
}

class _DeleteSelectService extends State<DeleteSelectService> {
  final formKey = GlobalKey<FormState>();
  TextEditingController serviceController = TextEditingController();
  int currentStep = 0;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? duration;

  //List<Message> messages = [];
  List<String> newDays = [];
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

  String? time2;

  String? getTime() {
    if (startTime == null && endTime == null) {
      return widget.time;
    } else {
      time2 =
          "${startTime.toString().substring(10, 15)} - ${endTime.toString().substring(10, 15)}";
      return time2;
    }
  }

  @override
  Widget build(BuildContext context) {
    // String selectedService =
    //     Provider.of<ReservationInfo>(context).selectedService;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff205375),
        title: const Text('Edit Service'),
        centerTitle: true,
      ),
      body: Stack(
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

          Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Image(
                image: AssetImage('assets/images/editService.png'),
                height: 250,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, top: 0, bottom: 0, right: 20),
                    child: TextFormField(
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: serviceController,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.only(left: 20, top: 20, bottom: 20),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(90.0)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[350],
                        hintText: widget.serviceName,
                        labelText: 'Service',
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


                  // child: TextFormField(
                  //   controller: serviceController,
                  //   decoration:  InputDecoration(
                  //     border: const OutlineInputBorder(),
                  //     labelText: 'Change service name',
                  //     hintText: widget.serviceName,
                  //     suffixIcon: const Icon(
                  //       Icons.design_services_rounded,
                  //     ),
                  //   ),
                  //   validator: (value){
                  //     if(value.toString().isEmpty){
                  //       return 'Please enter a new service name';
                  //     }
                  //     return null;
                  //   },
                  // ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: SelectWeekDays(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  days: daysSelected(),
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
                      },
                ),
              ),


              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              //   child: SelectWeekDays(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w500,
              //     days: daysSelected(),
              //     border: false,
              //     boxDecoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(30.0),
              //       gradient: const LinearGradient(
              //         begin: Alignment.topLeft,
              //         colors: [Color(0xff141E27), Color(0xff141E27)],
              //         tileMode:
              //             TileMode.repeated, // repeats the gradient over the canvas
              //       ),
              //     ),
              //     onSelect: (values) {
              //       // <== Callback to handle the selected days
              //       newDays = [];
              //       newDays.addAll(values);
              //     },
              //   ),
              // ),
              // Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              //     child: Align(
              //         alignment: Alignment.bottomCenter,
              //         child: SizedBox(
              //           width: 320,
              //           height: 50,
              //           child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //                 maximumSize: const Size.fromHeight(40),
              //                 primary: Colors.black),
              //             child: FittedBox(
              //               child: Text(
              //                 getTime()!,
              //                 style: const TextStyle(
              //                     fontSize: 15, color: Colors.white),
              //               ),
              //             ),
              //             onPressed: () async {
              //               TimeRange result = await showTimeRangePicker(
              //                   context: context,
              //                   start: const TimeOfDay(hour: 9, minute: 0),
              //                   end: const TimeOfDay(hour: 12, minute: 0),
              //                   disabledTime: TimeRange(
              //                       startTime: const TimeOfDay(hour: 18, minute: 0),
              //                       endTime: const TimeOfDay(hour: 6, minute: 0)),
              //                   disabledColor: Colors.red.withOpacity(0.5),
              //                   strokeWidth: 4,
              //                   ticks: 24,
              //                   ticksOffset: -7,
              //                   ticksLength: 15,
              //                   ticksColor: Colors.grey,
              //                   labels: [
              //                     "12 am",
              //                     "3 am",
              //                     "6 am",
              //                     "9 am",
              //                     "12 pm",
              //                     "3 pm",
              //                     "6 pm",
              //                     "9 pm"
              //                   ].asMap().entries.map((e) {
              //                     return ClockLabel.fromIndex(
              //                         idx: e.key, length: 8, text: e.value);
              //                   }).toList(),
              //                   labelOffset: 35,
              //                   rotateLabels: false,
              //                   padding: 60);
              //               setState(() {
              //                 startTime = result.startTime;
              //                 endTime = result.endTime;
              //               });
              //             },
              //           ),
              //         ))),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children:  [
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
                    buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.grey.shade400,
                    ),
                    buttonElevation: 2,
                    itemHeight: 40,
                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
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



              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              //   child: Center(
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton2(
              //         isExpanded: true,
              //         hint: Row(
              //           children: [
              //             const Icon(
              //               Icons.list,
              //               size: 16,
              //               color: Colors.yellow,
              //             ),
              //             const SizedBox(
              //               width: 4,
              //             ),
              //             Expanded(
              //               child: Text(
              //                 widget.duration,
              //                 style: const TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.yellow,
              //                 ),
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //             ),
              //           ],
              //         ),
              //         items: items
              //             .map((item) => DropdownMenuItem<String>(
              //                   value: item,
              //                   child: Text(
              //                     item,
              //                     style: const TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.white,
              //                     ),
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ))
              //             .toList(),
              //         value: selectedValue,
              //         onChanged: (value) {
              //           setState(() {
              //             selectedValue = value as String;
              //             duration = value;
              //           });
              //         },
              //         icon: const Icon(
              //           Icons.arrow_forward_ios_outlined,
              //         ),
              //         iconSize: 14,
              //         iconEnabledColor: Colors.yellow,
              //         iconDisabledColor: Colors.grey,
              //         buttonHeight: 50,
              //         buttonWidth: 160,
              //         buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              //         buttonDecoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(14),
              //           border: Border.all(
              //             color: Colors.black26,
              //           ),
              //           color: Colors.redAccent,
              //         ),
              //         buttonElevation: 2,
              //         itemHeight: 40,
              //         itemPadding: const EdgeInsets.only(left: 14, right: 14),
              //         dropdownMaxHeight: 200,
              //         dropdownWidth: 200,
              //         dropdownPadding: null,
              //         dropdownDecoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(14),
              //           color: Colors.redAccent,
              //         ),
              //         dropdownElevation: 8,
              //         scrollbarRadius: const Radius.circular(40),
              //         scrollbarThickness: 6,
              //         scrollbarAlwaysShow: true,
              //         offset: const Offset(-20, 0),
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox( height: 20,),
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
                      if (isValid) {
                        try {
                          updateServiceName(
                              servicename: serviceController.text);
                          updateTime(time: time2!);
                          updateDuration(duration: duration!);
                          updateDays(day: newDays);
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
              // Padding(
              //   padding: const EdgeInsets.only(top: 150, left: 25),
              //   child: Align(
              //     alignment: Alignment.bottomCenter,
              //     child: SizedBox(
              //       width: 250,
              //       height: 50,
              //       child: ElevatedButton(
              //         style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all<Color>(Colors.black),
              //         ),
              //         child: const Text(
              //           'Update',
              //           style: TextStyle(fontSize: 15),
              //         ),
              //         onPressed: () {
              //           final isValid = formKey.currentState!.validate();
              //           if(isValid) {
              //             try {
              //             updateServiceName(
              //                 servicename: serviceController.text);
              //             updateTime(time: time2!);
              //             updateDuration(duration: duration!);
              //             updateDays(day: newDays);
              //             AwesomeDialog(
              //               autoDismiss: false,
              //               context: context,
              //               dialogType: DialogType.SUCCES,
              //               animType: AnimType.BOTTOMSLIDE,
              //               title: 'Success',
              //               desc: 'Service updated successfully',
              //               btnOkText: "Go back",
              //               btnCancelColor: Colors.black87,
              //               btnOkOnPress: () {
              //                 Navigator.pop(context);
              //                 Navigator.pushReplacement(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) =>
              //                             const MyServices()));
              //               },
              //               onDissmissCallback: (d) {
              //                 Navigator.pop(context);
              //                 Navigator.pushReplacement(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) =>
              //                             const MyServices()));
              //               },
              //             ).show();
              //           } on FirebaseAuthException catch (error) {
              //             AwesomeDialog(
              //               autoDismiss: false,
              //               context: context,
              //               dialogType: DialogType.ERROR,
              //               animType: AnimType.BOTTOMSLIDE,
              //               title: 'Error',
              //               desc: '${error.message}',
              //               btnCancelText: 'Go back',
              //               btnCancelColor: Colors.black87,
              //               onDissmissCallback: (d) {
              //                 Navigator.pop(context);
              //                 Navigator.pushReplacement(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) =>
              //                             const MyServices()));
              //               },
              //               btnCancelOnPress: () {
              //                 Navigator.pop(context);
              //                 Navigator.pushReplacement(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) =>
              //                             const MyServices()));
              //               },
              //             ).show();
              //           }
              //           }
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Future updateDays({required List<String> day}) async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service')
          .doc(doc.id)
          .update({'days': day});
    }
  }

  Future updateServiceName({required String servicename}) async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service')
          .doc(doc.id)
          .update({'Service': servicename});
    }
  }

  Future updateTime({required String time}) async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service')
          .doc(doc.id)
          .update({'Time': time});
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
          .update({'Duration': duration});
    }
  }

  Future deleteService() async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
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
