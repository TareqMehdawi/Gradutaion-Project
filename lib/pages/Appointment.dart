import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widgets/user_class.dart';

class BookingScreen extends StatefulWidget {
  final String uid;
  final String empName;
  final String stdName;
  final String stdImage;

  const BookingScreen(
      {Key? key,
        required this.uid,
        required this.empName,
        required this.stdName,
        required Map officeHours,
        required this.stdImage})
      : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
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
  List? selectDay;

  int? onTimeSelect = -1;
  int isAvailable = 10;
  int isBooked = 2;
  String? t;
  String? t2;
  bool a = false;

  List sendItem(List items2) {
    List items = [];
    for (var i = 0; i < items2.length; i++) {
      String a = items2[i]["Service"];
      items.add(a);
    }
    return items;
  }

  List sendItem2(List items2) {
    List items = [];
    for (var i = 0; i < items2.length; i++) {
      if (items2[i]["Service"] == serviceSelect) {
        serviceIndex = i;
        for (var j = 0; j < items2[i]["days"].length; j++) {
          items.add(items2[i]["days"][j]);
        }
      }
    }
    return items;
  }

  List send(List bookedDay, String time, String duration) {
    List offichour = add(time);
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
    var min = two.difference(one).inMinutes / t;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Appointment booking',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else if (snapshot.hasData) {
                final List user = snapshot.data as List;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/a.png'),
                      height: 250,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Expanded(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 18),
                              child: Text(
                                'Enter Appointment information',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
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
                                          'Select Service',
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
                                      selectedValue = value as String;
                                      serviceSelect = value;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.yellow,
                                  iconDisabledColor: Colors.grey,
                                  buttonHeight: 50,
                                  buttonWidth: 500,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.redAccent,
                                  ),
                                  buttonElevation: 2,
                                  itemHeight: 40,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  dropdownMaxHeight: 200,
                                  dropdownPadding: null,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.redAccent,
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
                                          'Select Day',
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
                                      //print(value);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.yellow,
                                  iconDisabledColor: Colors.grey,
                                  buttonHeight: 50,
                                  buttonWidth: 500,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.redAccent,
                                  ),
                                  buttonElevation: 2,
                                  itemHeight: 40,
                                  itemPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  dropdownMaxHeight: 200,
                                  dropdownPadding: null,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.redAccent,
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
                            if (isSelected == true)
                              FutureBuilder(
                                  future: getTime(user),
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
                                                user[serviceIndex!]["Time"],
                                                user[serviceIndex!]
                                                ["Duration"])
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
                                                            user[serviceIndex!]
                                                            ["Time"],
                                                            user[serviceIndex!][
                                                            "Duration"])[index];
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
                                                              ? Colors.blue
                                                              : Colors.white),
                                                      height: 30,
                                                      child: Center(
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child: Text(
                                                              send(
                                                                  user2,
                                                                  user[serviceIndex!]
                                                                  ["Time"],
                                                                  user[serviceIndex!][
                                                                  "Duration"])[index],
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.black,
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
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    primary: Colors.indigo,
                                    onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    try {
                                      await checkUser();
                                      await setReservation(
                                          empName: widget.empName,
                                          empId: widget.uid,
                                          service: serviceSelect!,
                                          people: 10,
                                          currentTime: selectedTime!,
                                          currentDate: daySelect!,
                                          studentName: widget.stdName);
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
                                            Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                          },
                                          onDissmissCallback: (d) {
                                            return Navigator.of(context)
                                                .popUntil(
                                                    (route) => route.isFirst);
                                          }).show();
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
                                            Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                          },
                                          onDissmissCallback: (d) {
                                            return Navigator.of(context)
                                                .popUntil(
                                                    (route) => route.isFirst);
                                          }).show();
                                    }
                                  },
                                  child: Text(
                                    "Book Appointment",
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                //print(snapshot.error);
                /////////////////////////////
                return const Center(
                  child: Text('Loading...'),
                );
              }
            }),
      ),
    );
  }

  Future readUser() async {
    List data = [];
    setState(() {
      isLoading = true;
    });
    final getUser = FirebaseFirestore.instance
        .collection('Service')
        .where('id', isEqualTo: widget.uid);
    final snapshot = await getUser.get();
    for (var ele in snapshot.docs) {
      data.add(ele.data());
    }
    if (data.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
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
      print(true);
      return true;
    } else {
      print(false);
      throw Exception();
    }
  }

  Future setReservation({
    required String empName,
    required String empId,
    required String service,
    required int people,
    required String currentTime,
    required String currentDate,
    required String studentName,
  }) async {
    final docUser = FirebaseFirestore.instance.collection('reservation').doc();
    final user = StudentsReservation(
      id: currentUser.uid,
      empName: empName,
      empId: empId,
      service: service,
      people: people,
      time: currentTime,
      date: currentDate,
      student: studentName,
      image: widget.stdImage,
    );
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
