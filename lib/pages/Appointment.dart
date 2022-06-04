import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widgets/backbutton_widget.dart';
import '../widgets/user_class.dart';
import 'navigation_drawer.dart';

class BookingScreen extends StatefulWidget {
  final String uid;
  final String empName;
  final String stdName;
  final String stdImage;
  final String token;

  const BookingScreen({
    Key? key,
    required this.uid,
    required this.empName,
    required this.stdName,
    required Map officeHours,
    required this.stdImage,
    required this.token,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select Time';
  String? dateTime;
  String? selectedValue;
  String? selectedValue2;
  String? serviceSelect;
  String? daySelect;
  int? serviceIndex;
  bool isSelected = false;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String? selectedTime;
  Map? selectDay;
  String office_hour_selected = "";
  String duration_selected = "";
  String? imageemp;
  int? onTimeSelect = -1;
  int isAvailable = 10;
  int isBooked = 2;
  String? t;
  String? t2;
  bool a = false;
  bool setService=false;
  bool setDay =false;
  bool setTime =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: FutureBuilder(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else if (snapshot.hasData) {
              final List user = snapshot.data as List;
              return Stack(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: customBackButton(color: Color(0xff205375)),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .1,
                        ),
                        const Image(
                          image: AssetImage('assets/images/app.gif'),
                          height: 250,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                                      'Select Service',
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
                              items: sendItem(user)
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
                              onChanged: (value) {
                                setState(() {
                                  selectedValue2 = null;
                                  isSelected = false;
                                  selectedValue = value as String;
                                  serviceSelect = value;
                                  setService=true;
                                });
                              },
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: const [
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
                                      'Select Day',
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
                              items: sendItem2(user)
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
                                setState(() {
                                  isSelected = true;
                                  selectedValue2 = value as String;
                                  daySelect = value;
                                  setDay=true;
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
                                color: Color(0xff205375),
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                            ),
                          ),
                        ),
                        if (isSelected == true)
                          FutureBuilder(
                              future: getTime(user),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong');
                                } else if (snapshot.hasData) {
                                  final List user2 = snapshot.data as List;
                                  return Flexible(
                                    child: Container(
                                      height: 150,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: send(user2,
                                                user[serviceIndex!]["duration"])
                                            .length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 10),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                            onTap: () {
                                              setState(() {
                                                onTimeSelect = index;
                                                selectedTime = send(
                                                    user2,
                                                    user[serviceIndex!]
                                                        ["duration"])[index];
                                                setTime=true;
                                                //onTimeSelect = !onTimeSelect;
                                              });
                                            },
                                            splashColor: Colors.indigo,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32.0),
                                                  color: index == onTimeSelect
                                                      ? Color(0xff205375)
                                                      : Colors.grey.shade400),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 25.0),
                                                  child: Text(
                                                    send(
                                                        user2,
                                                        user[serviceIndex!][
                                                            "duration"])[index],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: SizedBox(
                                          height: 100,
                                          child: Image.asset(
                                              "assets/images/loading.gif"),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: SizedBox(
                            width: double.infinity,
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: ElevatedButton(
                                child: Text(
                                  "Book Appointment",
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    if(setService==true && setDay==true && setTime==true){
                                    await checkUser();
                                    await setReservation(
                                      empName: widget.empName,
                                      empId: widget.uid,
                                      service: serviceSelect!,
                                      currentTime: selectedTime!,
                                      currentDate: daySelect!,
                                      studentName: widget.stdName,
                                      imageemp: imageemp!,
                                    );
                                    sendPushMessage(
                                        //'cbSymk6TS4y28q_OjfU1Nn:APA91bHFQ30eB-KIYDzCIxl1Cw1U3HmiaezitixHSgdGwl_a81Xd3wWkBt-1N0uvRbJDF1UlbtIAdJ85WrczPRrs8sb2irdJnQG9IJd_2zp24soEAzBIHgE6twUelfCmg4fSqCBNoaah',
                                        widget.token,
                                        'Appointment Scheduled',
                                        '${widget.stdName} reserved a new appointment');
                                    AwesomeDialog(
                                        autoDismiss: false,
                                        context: context,
                                        dialogType: DialogType.SUCCES,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Success',
                                        desc:
                                            'Appointment Scheduled Successfully',
                                        btnOkText: "Ok",
                                        btnOkOnPress: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const NavigationDrawer()));
                                        },
                                        onDissmissCallback: (d) {
                                          return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const NavigationDrawer()));


                                        }).show();}
                                    else{
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
                                  } catch (e) {
                                    AwesomeDialog(
                                        autoDismiss: false,
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'ERROR',
                                        desc:
                                            'You already have an appointment with ${widget.empName}',
                                        btnOkText: "Go Back",
                                        btnOkColor: Colors.red,
                                        btnOkOnPress: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const NavigationDrawer()));

                                        },
                                        onDissmissCallback: (d) {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const NavigationDrawer()));

                                        }).show();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  primary: Color(0xff205375),
                                  onPrimary: Color(0xff205375),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
                return Scaffold(
                  appBar: AppBar( centerTitle: true,
                  title: Text("Appointment"),
                  backgroundColor:  const Color(0xff205375),),
                  body: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.1),
                        child: Image.asset('assets/images/Schedule-bro.png'),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 150.0),
                            child: Center(
                              child: Wrap(
                                children: [
                                  Text(
                                    "${widget.empName} didn't add any services!",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff205375),
                                        fontWeight: FontWeight.bold),
                                  ),


                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              };
            }
          ),
    );
  }

  List sendItem(List items2) {
    List items = [];
    for (var i = 0; i < items2.length; i++) {
      String a = items2[i]["service"];
      items.add(a);
    }
    imageemp = items2[0]["image"];
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

  List send(List bookedDay, String duration) {
    String Time = "";
    for (var day in selectDay!.keys) {
      if (day == daySelect) {
        Time = selectDay![day].toString();
        break;
      }
    }
    office_hour_selected = Time;
    duration_selected = duration;

    List offichour = add(Time);
    List availableTime = count(bookedDay, offichour);
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
        hours = hours + 1;
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

  Future readUser() async {
    List data = [];
    final getUser = FirebaseFirestore.instance
        .collection('Service')
        .where('id', isEqualTo: widget.uid);
    final snapshot = await getUser.get();
    for (var ele in snapshot.docs) {
      data.add(ele.data());
    }
    if (data.isNotEmpty) {
      return data;
    }
  }

  Future checkUser() async {
    List data = [];
    final getUser = FirebaseFirestore.instance
        .collection('reservation')
        .where('id', isEqualTo: currentUser.uid)
        .where('empId', isEqualTo: widget.uid);
    final snapshot = await getUser.get();
    for (var ele in snapshot.docs) {
      data.add(ele.data());
    }
    if (data.isEmpty) {
      return true;
    } else {
      throw Exception();
    }
  }

  Future setReservation(
      {required String empName,
      required String empId,
      required String service,
      required String currentTime,
      required String currentDate,
      required String studentName,
      required String imageemp}) async {
    final docUser = FirebaseFirestore.instance.collection('reservation').doc();
    final user = StudentsReservation(
        id: currentUser.uid,
        empName: empName,
        empId: empId,
        service: service,
        time: currentTime,
        date: currentDate,
        student: studentName,
        image: widget.stdImage,
        duration: duration_selected,
        officehour: office_hour_selected,
        imageemp: imageemp);
    final json = user.toJson();
    await docUser.set(json);
  }

  Future getTime(List user1) async {
    List data = [];
    final docUser2 = await FirebaseFirestore.instance
        .collection('reservation')
        .where('empId', isEqualTo: widget.uid)
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
