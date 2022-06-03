import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'backbutton_widget.dart';

class EditScreen extends StatefulWidget {
  final String student_id;
  final String emp_id;
  final String service;
  final String time;
  final String officeHour;
  final String duration;
  final String day;
  final String token;
  final String stdName;

  const EditScreen({
    Key? key,
    required this.student_id,
    required this.time,
    required this.service,
    required this.emp_id,
    required this.officeHour,
    required this.duration,
    required this.day,
    required this.token,
    required this.stdName,
  }) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _timeController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select Time';
  String? dateTime;
  bool isLoading = false;
  String? selectedValue;
  String? selectedValue2;
  String? serviceSelect;
  String? daySelect;
  int? serviceIndex;
  bool isSelected = false;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String? selectedTime;
  Map? selectDay;
  List empty = [];
  int? onTimeSelect = -1;
  int isAvailable = 10;
  int isBooked = 2;
  String? t;
  String? t2;
  bool a = false;

  List sendItem(List items2) {
    List items = [];
    for (var i = 0; i < items2.length; i++) {
      String a = items2[i]["service"];
      items.add(a);
    }
    return items;
  }

  List sendItem2(List items2) {
    List items = [];
    Map daysAndtimes = {};
    for (var i = 0; i < items2.length; i++) {
      if (items2[i]["service"] == serviceSelect) {
        serviceIndex = i;
        Map a = {};
        a.addAll(items2[i]["days"]);
        for (var j in a.keys) {
          items.add(j);
          Map m1 = {j.toString().trim(): a[j].toString().trim()};
          daysAndtimes.addAll(m1);
        }
      }
    }
    selectDay = daysAndtimes;
    return items;
  }

  List send(List bookedDay, String duration, String hour) {
    List offichour2 = add(hour);
    List availableTime = count(bookedDay, offichour2);
    List endList = [];
    int t = int.parse(duration.substring(0, 2));
    int fo = availableTime.length - 1;

    switch (t) {
      case 5:
        endList = availableTime;
        break;
      case 10:
        for (int i = 0; i < fo; i++) {
          String endHourCurrently =
              availableTime[i].toString().substring(8, 13);
          String startHourFromNext = '';

          startHourFromNext = availableTime[i + 1].toString().substring(0, 5);

          if (startHourFromNext == endHourCurrently) {
            endList.add(
                "${availableTime[i].toString().substring(0, 5)} - ${availableTime[i + 1].toString().substring(8, 13)}");
          }
        }
        break;
      case 15:
        int count = 0;
        int b = 0;
        String start = "";
        for (int i = 0; i < fo; i++) {
          String endHourCurrently =
              availableTime[i].toString().substring(8, 13);
          String startHourFromNext = '';

          startHourFromNext = availableTime[i + 1].toString().substring(0, 5);

          if (startHourFromNext == endHourCurrently && count == 0) {
            count++;

            if (count == 1) {
              start = availableTime[i].toString().substring(0, 5);
              b = i;
            }
          } else if (count > 0 &&
              b + 1 == i &&
              startHourFromNext == endHourCurrently) {
            count++;
          } else {
            count = 0;
          }
          if (count == 2) {
            endList.add(
                "$start - ${availableTime[i + 1].toString().substring(8, 13)}");
            start = "";
            count = 0;
            i = b;
          }
        }
        break;
      case 20:
        int count = 0;
        int b = 0;
        String start = "";
        for (int i = 0; i < fo; i++) {
          String endHourCurrently =
              availableTime[i].toString().substring(8, 13);
          String startHourFromNext = '';

          startHourFromNext = availableTime[i + 1].toString().substring(0, 5);

          if (startHourFromNext == endHourCurrently && count == 0) {
            count++;

            if (count == 1) {
              start = availableTime[i].toString().substring(0, 5);
              b = i;
            }
          } else if (count > 0 &&
              (b + 1 == i || b + 2 == i) &&
              startHourFromNext == endHourCurrently) {
            count++;
          } else {
            count = 0;
          }
          if (count == 3) {
            endList.add(
                "$start - ${availableTime[i + 1].toString().substring(8, 13)}");
            start = "";
            count = 0;
            i = b;
          }
        }
        break;
      case 25:
        int count = 0;
        int b = 0;
        String start = "";
        for (int i = 0; i < fo; i++) {
          String endHourCurrently =
              availableTime[i].toString().substring(8, 13);
          String startHourFromNext = '';

          startHourFromNext = availableTime[i + 1].toString().substring(0, 5);

          if (startHourFromNext == endHourCurrently && count == 0) {
            count++;

            if (count == 1) {
              start = availableTime[i].toString().substring(0, 5);
              b = i;
            }
          } else if (count > 0 &&
              (b + 1 == i || b + 2 == i || b + 3 == i) &&
              startHourFromNext == endHourCurrently) {
            count++;
          } else {
            count = 0;
          }
          if (count == 4) {
            endList.add(
                "$start - ${availableTime[i + 1].toString().substring(8, 13)}");
            start = "";
            count = 0;
            i = b;
          }
        }
        break;
      case 30:
        int count = 0;
        int b = 0;
        String start = "";
        for (int i = 0; i < fo; i++) {
          String endHourCurrently =
              availableTime[i].toString().substring(8, 13);
          String startHourFromNext = '';

          startHourFromNext = availableTime[i + 1].toString().substring(0, 5);

          if (startHourFromNext == endHourCurrently && count == 0) {
            count++;

            if (count == 1) {
              start = availableTime[i].toString().substring(0, 5);
              b = i;
            }
          } else if (count > 0 &&
              (b + 1 == i || b + 2 == i || b + 3 == i || b + 4 == i) &&
              startHourFromNext == endHourCurrently) {
            count++;
          } else {
            count = 0;
          }
          if (count == 5) {
            endList.add(
                "$start - ${availableTime[i + 1].toString().substring(8, 13)}");
            start = "";
            count = 0;
            i = b;
          }
        }
        break;
    }

    return endList;
  }

  add(String doctorOfficeHours) {
    int? hours;
    int? minutes;
    String? hour;
    String? minute;
    String? oldHour;
    String? newHour;
    List notAvailable = [];
    int fo = countHours(5, doctorOfficeHours);
    for (int i = 0; i < fo; i++) {
      String startHour1 = doctorOfficeHours.toString().substring(0, 2);
      String startMin1 = doctorOfficeHours.toString().substring(3, 5);
      hour = doctorOfficeHours.toString().substring(0, 2);
      minute = doctorOfficeHours.toString().substring(3, 5);
      hours = int.parse(doctorOfficeHours.toString().substring(0, 2));
      minutes = int.parse(doctorOfficeHours.toString().substring(3, 5));
      oldHour = "$startHour1:$startMin1 - ";
      if (minutes >= 0 && minutes < 55) {
        minutes = (minutes + 5);
        minute = minutes.toString().padLeft(2, '0');
        hour = hours.toString().padLeft(2, '0');
        newHour = "$hour:$minute";
        doctorOfficeHours = newHour;
        notAvailable.add(oldHour + newHour);
      } else {
        minute = '00';
        hours = hours +1;
        hour = hours.toString().padLeft(2, '0');
        newHour = "$hour:$minute";
        doctorOfficeHours = newHour;
        notAvailable.add(oldHour + newHour);
      }
    }
    return notAvailable;
  }

  countHours(int t, String doctorOfficeHours) {
    var format = DateFormat("HH:mm");
    int startHour = int.parse(doctorOfficeHours.substring(0, 2));
    int endHour = int.parse(doctorOfficeHours.substring(8, 10));
    int endMin = int.parse(doctorOfficeHours.substring(11, 13));
    var oneTime = doctorOfficeHours.substring(0, 5);
    var secTime = doctorOfficeHours.substring(8, 13);
    if (startHour > endHour) {
      endHour = endHour + 12;
      secTime = "$endHour:$endMin";
    }
    var one = format.parse(oneTime);
    var two = format.parse(secTime);
    var min = two.difference(one).inMinutes / t;
    var intMin = min.floor();

    return intMin;
  }



  count(List b, List notAvailable) {
    List c = [];
    int count = 0;
    int count2 = 0;
    bool as = false;

    for (int i = 0; i < b.length; i++) {
      for (int j = 0; j < notAvailable.length; j++) {
        if (b[i].toString().substring(0, 5) ==
            notAvailable[j].toString().substring(0, 5)) {
          count++;
          as = true;
        }
        if (as == true) {
          c.add(notAvailable[j]);
        }

        if (b[i].toString().substring(8, 13) ==
            notAvailable[j].toString().substring(8, 13)) {
          count2++;
          as = false;
          break;
        }
      }
      for (int i = 0; i < c.length; i++) {
        for (int j = 0; j < notAvailable.length; j++) {
          if (c[i] == notAvailable[j]) {
            notAvailable.removeAt(j);
          }
        }
      }
    }
    return notAvailable;
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime!,
        alwaysUse24HourFormat: false);

    setState(() {
      timeText = formattedTime;
      _timeController.text = timeText;
    });
    dateTime = selectedTime.toString().substring(10, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Stack(
        children: [
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 35,
              ),
              customBackButton(color: Color(0xff205375)),
              const Image(
                image: AssetImage('assets/images/app.gif'),
                height: 200,
              ),
              Form(
                key: _formKey,
                child: Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 18),
                        child: Center(
                          child: Text(
                            'Appointment Update',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
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
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.service,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: empty
                                .map(
                                  (item) => DropdownMenuItem(
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
                                  ),
                                )
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {},
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor: Colors.grey.shade400,
                            iconDisabledColor: Color(0xff205375),
                            buttonHeight: 50,
                            buttonWidth: 500,
                            buttonPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: Color(0xff205375),
                            ),
                            buttonElevation: 2,
                            itemHeight: 40,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            dropdownMaxHeight: 200,
                            dropdownPadding: null,
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Color(0xff205375),
                            ),
                            dropdownElevation: 8,
                            scrollbarRadius: const Radius.circular(40),
                            scrollbarThickness: 6,
                            scrollbarAlwaysShow: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                                    widget.day,
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
                            items: empty
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
                            value: selectedValue2,
                            onChanged: (value) {
                              setState(() {});
                            },
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
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                          future: getTime(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            } else if (snapshot.hasData) {
                              final List user2 = snapshot.data as List;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: send(
                                      user2,
                                      widget.duration,
                                      widget.officeHour,
                                    ).length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            onTimeSelect = index;
                                            selectedTime = send(
                                              user2,
                                              widget.duration,
                                              widget.officeHour,
                                            )[index];
                                            //onTimeSelect = !onTimeSelect;
                                          });
                                        },
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                        splashColor: Colors.indigo,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                              color: index == onTimeSelect
                                                  ? Color(0xff205375)
                                                  : Colors.grey.shade400),
                                          height: 30,
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              send(
                                                user2,
                                                widget.duration,
                                                widget.officeHour,
                                              )[index],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('hi'),
                              );
                            }
                          }),
                      const SizedBox(
                        height: 10,
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
                            onPressed: () async {
                              //final isValid = formKey.currentState!
                              //     .validate();
                              // if (isValid) {
                              try {
                                updateTime();
                                sendPushMessage(
                                    //'cbSymk6TS4y28q_OjfU1Nn:APA91bHFQ30eB-KIYDzCIxl1Cw1U3HmiaezitixHSgdGwl_a81Xd3wWkBt-1N0uvRbJDF1UlbtIAdJ85WrczPRrs8sb2irdJnQG9IJd_2zp24soEAzBIHgE6twUelfCmg4fSqCBNoaah',
                                    widget.token,
                                    'An Appointment has been rescheduled',
                                    'Appointment Updated');
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
                                  },
                                  onDissmissCallback: (d) {
                                    Navigator.pop(context);
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
                                  },
                                  btnCancelOnPress: () {
                                    Navigator.pop(context);
                                  },
                                ).show();
                              }
                              ;
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
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, top: 20, bottom: 20, right: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            child: Text(
                              "Delete",
                              style: GoogleFonts.lato(
                                color: Color(0xff205375),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Warning',
                                desc:
                                    'Are you sure you want to delete this service',
                                btnOkText: "Delete",
                                btnCancelText: 'Cancel',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {
                                  try {
                                    deleteService();
                                    sendPushMessage(
                                        //'cbSymk6TS4y28q_OjfU1Nn:APA91bHFQ30eB-KIYDzCIxl1Cw1U3HmiaezitixHSgdGwl_a81Xd3wWkBt-1N0uvRbJDF1UlbtIAdJ85WrczPRrs8sb2irdJnQG9IJd_2zp24soEAzBIHgE6twUelfCmg4fSqCBNoaah',
                                        widget.token,
                                        //'fuyTrGHBSh6BQt9XvHr7Ba:APA91bHyYkF8wIOf8-qrpW0saQx4ySqRWoSN0RLOYZ-gms8KhroIQDlCll52xcZLNnLL1aEr5JqU-N6zWvTAENj56Jkxssw8-Gj3fxibi0eTiVYPr0FWqJff0H9UwuFrSeCX0Kn3Fweu',
                                        'An Appointment has been rescheduled',
                                        'Appointment Updated');
                                    AwesomeDialog(
                                      autoDismiss: false,
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      animType: AnimType.BOTTOMSLIDE,
                                      title: 'Success',
                                      desc: 'Service deleted successfully',
                                      btnOkText: 'Go back',
                                      btnCancelColor: Colors.black87,
                                      onDissmissCallback: (d) {
                                        Navigator.pop(context);
                                      },
                                      btnOkOnPress: () {
                                        Navigator.pop(context);
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
                                      },
                                      btnCancelOnPress: () {
                                        Navigator.pop(context);
                                      },
                                    ).show();
                                  }
                                },
                              ).show();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: Colors.grey.shade400,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future deleteService() async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('reservation')
        .where('service', isEqualTo: widget.service)
        .where('empId', isEqualTo: widget.emp_id)
        .where('id', isEqualTo: widget.student_id)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('reservation')
          .doc(doc.id)
          .delete();
    }
  }

  Future updateTime() async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('reservation')
        .where('service', isEqualTo: widget.service)
        .where('empId', isEqualTo: widget.emp_id)
        .where('id', isEqualTo: widget.student_id)
        .get();
    for (var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('reservation')
          .doc(doc.id)
          .update({'time': selectedTime});
    }
  }

  Future getTime() async {
    List data = [];
    final docUser2 = await FirebaseFirestore.instance
        .collection('reservation')
        .where('empId', isEqualTo: widget.emp_id)
        .where('date', isEqualTo: daySelect)
        .get();
    for (var ele in docUser2.docs) {
      data.add(ele.data()['time']);
    }
    return data;
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAc7t946A:APA91bFfNHbG4zCoFxqgR8-i3UnX0E1SkSGJZ_iW5k6YSI-uIGpVYMqP4lgw9j45xVDXX1KnGDvW9gSejPu-tHdQFP_I11FlH_qYTrs24X3sBR7pLcbUGwPt8Qres-IoFHWCw8VuFwjw',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
}
