import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widgets/user_class.dart';

class EditScreen extends StatefulWidget {
  final String student_id;
  final String emp_id;
  final String service;
  final String time;
  final String officeHour;
  final String duration;
  final String day;

  const EditScreen(
      {Key? key,
        required this.student_id,
        required this.time,
        required this.service,
        required this.emp_id,
        required this.officeHour,
        required this.duration,
      required this.day})
      : super(key: key);

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
          Map m1 = { j.toString().trim(): a[j].toString().trim()};
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
                "${availableTime[i].toString().substring(
                    0, 5)} - ${availableTime[i + 1].toString().substring(
                    8, 13)}");
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
        hours = makeHour(hours);
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
    var min = two
        .difference(one)
        .inMinutes / t;
    var intMin = min.floor();

    return intMin;
  }

  int makeHour(int hour) {
    if (hour < 12) {
      hour = hour + 1;
      return hour;
    } else {
      hour = 1;
      return hour;
    }
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .3,
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .3,
                ),
              ),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(height: 15,),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.arrow_back, color: Color(0xff205375),),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
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
                            'Appointment booking',
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
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15.0),
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
                                  (item) =>
                                  DropdownMenuItem(
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
                            buttonPadding: const EdgeInsets.only(
                                left: 14, right: 14),
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: Color(0xff205375),
                            ),
                            buttonElevation: 2,
                            itemHeight: 40,
                            itemPadding: const EdgeInsets.symmetric(
                                horizontal: 14),
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
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15.0),
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
                                .map((item) =>
                                DropdownMenuItem<String>(
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
                            buttonPadding: const EdgeInsets.only(
                                left: 14, right: 14),
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: Colors.grey.shade400,
                            ),
                            buttonElevation: 2,
                            itemHeight: 40,
                            itemPadding: const EdgeInsets.only(
                                left: 14, right: 14),
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
                                      widget.officeHour,)
                                        .length,
                                    itemBuilder: (BuildContext context,
                                        int index) =>
                                        Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                onTimeSelect = index;
                                                selectedTime = send(
                                                  user2,
                                                  widget.duration,
                                                  widget.officeHour,)[index];
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
                                                  BorderRadius.circular(
                                                      32.0),
                                                  color:
                                                  index == onTimeSelect
                                                      ? Color(0xff205375)
                                                      : Colors.grey.shade400),
                                              height: 30,
                                              child: Center(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: Text(
                                                      send(
                                                        user2,
                                                        widget.duration,
                                                        widget
                                                            .officeHour,)[index],
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold),
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
                                  };
                              }
                              ,
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
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, top: 0, bottom: 0, right: 20),
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
                                btnOkOnPress: () {
                                  try {
                                    deleteService();
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


                      // SizedBox(
                      //   height: 50,
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 18.0),
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         elevation: 2,
                      //         primary: Colors.indigo,
                      //         onPrimary: Colors.black,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(32.0),
                      //         ),
                      //       ),
                      //       onPressed: () async {
                      //         try {
                      //           await checkUser();
                      //           await setReservation(
                      //               empName: widget.empName,
                      //               empId: widget.uid,
                      //               service: serviceSelect!,
                      //               people: 10,
                      //               currentTime: selectedTime!,
                      //               currentDate: daySelect!,
                      //               studentName: widget.stdName);
                      //           AwesomeDialog(
                      //               autoDismiss: false,
                      //               context: context,
                      //               dialogType: DialogType.SUCCES,
                      //               animType: AnimType.BOTTOMSLIDE,
                      //               title: 'Success',
                      //               desc:
                      //               'Appointment Scheduled Successfully',
                      //               btnOkText: "Ok",
                      //               btnOkOnPress: () {
                      //                 Navigator.of(context).popUntil(
                      //                         (route) => route.isFirst);
                      //               },
                      //               onDissmissCallback: (d) {
                      //                 return Navigator.of(context)
                      //                     .popUntil(
                      //                         (route) => route.isFirst);
                      //               }).show();
                      //         } catch (e) {
                      //           AwesomeDialog(
                      //               autoDismiss: false,
                      //               context: context,
                      //               dialogType: DialogType.ERROR,
                      //               animType: AnimType.BOTTOMSLIDE,
                      //               title: 'ERROR',
                      //               desc:
                      //               'You already have an appointment with ${widget.empName}',
                      //               btnOkText: "Go Back",
                      //               btnOkColor: Colors.red,
                      //               btnOkOnPress: () {
                      //                 Navigator.of(context).popUntil(
                      //                         (route) => route.isFirst);
                      //               },
                      //               onDissmissCallback: (d) {
                      //                 return Navigator.of(context)
                      //                     .popUntil(
                      //                         (route) => route.isFirst);
                      //               }).show();
                      //         }
                      //       },
                      //       child: Text(
                      //         "Book Appointment",
                      //         style: GoogleFonts.lato(
                      //           color: Colors.white,
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
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

  // Future readUser() async {
  //   List data = [];
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final getUser = FirebaseFirestore.instance
  //       .collection('Service')
  //       .where('id', isEqualTo: widget.emp_id);
  //   final snapshot = await getUser.get();
  //   for (var ele in snapshot.docs) {
  //     data.add(ele.data());
  //   }
  //   if (data.isNotEmpty) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return data;
  //   }
  // }

  // Future checkUser() async {
  //   List data = [];
  //   final getUser = FirebaseFirestore.instance
  //       .collection('reservation')
  //       .where('id', isEqualTo: currentUser.uid)
  //       .where('empId', isEqualTo: widget.emp_id);
  //   final snapshot = await getUser.get();
  //   for (var ele in snapshot.docs) {
  //     data.add(ele.data());
  //   }
  //   if (data.isEmpty) {
  //     print(true);
  //     return true;
  //   } else {
  //     print(false);
  //     throw Exception();
  //   }
  // }

  // Future setReservation({
  //   required String empName,
  //   required String empId,
  //   required String service,
  //   required int people,
  //   required String currentTime,
  //   required String currentDate,
  //   required String studentName,
  // }) async {
  //   final docUser = FirebaseFirestore.instance.collection('reservation').doc();
  //   final user = StudentsReservation(
  //     id: currentUser.uid,
  //     empName: empName,
  //     empId: empId,
  //     service: service,
  //     people: people,
  //     time: currentTime,
  //     date: currentDate,
  //     student: studentName,
  //     image: widget.stdImage,
  //   );
  //   final json = user.toJson();
  //   await docUser.set(json);
  // }
  Future deleteService() async {
    final docUser2 = await FirebaseFirestore.instance
        .collection('reservation')
        .where('service', isEqualTo: widget.service)
        .where('empId', isEqualTo: widget.emp_id).where(
        'id', isEqualTo: widget.student_id).get();
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
        .where('empId', isEqualTo: widget.emp_id).where(
        'id', isEqualTo: widget.student_id)
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
// Color getColor(List bookedDay, List Time, int Ind, int onTime) {
//
//
//   if (a == false) {
//     for (int i = 0; i < bookedDay.length; i++) {
//       if (Time[Ind] == bookedDay[i]) {
//         return Colors.red;
//       } else if (Time[Ind].toString().substring(0, 7) ==
//           bookedDay[i].toString().substring(0, 7) &&
//           Time[Ind].toString().substring(9, 17) !=
//               bookedDay[i].toString().substring(9, 17)) {
//         a = true;
//         t = bookedDay[i].toString().substring(9, 17);
//         //t2 = Time[Ind+1].toString().substring(0, 7);
//         //  print(t2);
//       }
//       //  if(Time[Ind].toString().substring(0, 3)==bookedDay[i].toString().substring(0, 3) &&)
//     }
//   }
//   if (a == true) {
//     //print(Time[Ind].toString().substring(9, 17));
//     if (Time[Ind].toString().substring(9, 17).trim() == t?.trim() ) {
//       //print(Time[Ind].toString().substring(9, 17).trim());
//       a = false;
//       t = "";
//       return Colors.red;
//     } else
//       return Colors.red;
//   }
//   if (Ind == onTime) {
//     return Colors.indigo;
//   }
//
//   return Colors.white12;
// }

// void sendItem4(List items2) {
//   selectDay = items2;
// }

// List sendItem3(List items2) {
//   List items = [];
//   int duration =
//   int.parse(items2[serviceIndex!]["Duration"].toString().substring(0, 2));
//   int endMin =
//   int.parse(items2[serviceIndex!]["Time"].toString().substring(11, 13));
//   int endHour =
//   int.parse(items2[serviceIndex!]["Time"].toString().substring(8, 10));
//   // print(duration);
//   // print(endMin);
//   // print(items2[serviceIndex!]["days"][0]);
//   //
//   // print(endHour);
//   int min =
//   int.parse(items2[serviceIndex!]["Time"].toString().substring(3, 5));
//   int hour =
//   int.parse(items2[serviceIndex!]["Time"].toString().substring(0, 2));
//   int min2;
//   while (hour <= endHour) {
//     int minute = min;
//     int ho = hour;
//     min = min + duration;
//     if (min < 60) {
//       if (!(min > endMin && hour == endHour)) {
//         if (hour <= endHour) {
//           items.add(
//               '${ho.toString().padLeft(2, "0")} : ${minute.toString().padLeft(2, "0")} - ${hour.toString().padLeft(2, "0")} : ${min.toString().padLeft(2, "0")} ');
//         }
//       }
//     } else if (min >= 60) {
//       min2 = min - 60;
//       hour++;
//       if (!(min2 > endMin && hour == endHour)) {
//         if (hour <= endHour) {
//           items.add(
//               '${ho.toString().padLeft(2, "0")} : ${minute.toString().padLeft(2, "0")} - ${hour.toString().padLeft(2, "0")} : ${min2.toString().padLeft(2, "0")} ');
//         }
//         min = min2;
//       }
//     }
//   }
//   // print(items);
//
//   return items;
// }
}
