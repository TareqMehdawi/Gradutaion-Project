import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// getTime() {
// //   for (var availableItem in available) {
// //     for (var bookItem in booked) {
// //       if (availableItem
// //           .toString()
// //           .startsWith(bookItem.toString().substring(0, 5))) {
// //         print('Start time of available = Start time of booked');
// //         notAvailable.add(availableItem.toString().substring(0, 5));
// //         print(notAvailable);
// //       }
// //       if (availableItem.toString().substring(8, 13) ==
// //           bookItem.toString().substring(8, 13)) {
// //         notAvailable2.add(availableItem.toString().substring(8, 13));
// //         print('end time of available = end time of booked');
// //         print(notAvailable2);
// //         print(availableItem.toString().substring(0, 2));
// //         print(bookItem.toString().substring(0, 2));
// //         print(availableItem.toString().substring(3, 6));
// //         print(bookItem.toString().substring(3, 6));
// //         //availableItem.toString().substring(8, 13)
// //       }
// //       if (availableItem.toString().substring(0, 2) ==
// //               bookItem.toString().substring(0, 2) &&
// //           availableItem.toString().substring(3, 6) !=
// //               bookItem.toString().substring(3, 6)) {
// //         notAvailable3.add(availableItem.toString().substring(3, 6));
// //         print('start time of available minutes = start time of booked minutes');
// //         print(notAvailable3);
// //       }
// //     }
// //   }
// }

class Tareq extends StatefulWidget {
  const Tareq({Key? key}) : super(key: key);

  @override
  State<Tareq> createState() => _TareqState();
}

class _TareqState extends State<Tareq> {
  bool s = false;
  bool m = false;

  // String hour = TimeOfDay.now().hourOfPeriod.toString().padLeft(2, '0');
  // String minutes = TimeOfDay.now().minute.toString().padLeft(2, '0');
  final user = FirebaseAuth.instance.currentUser!;

  // var newDoc = [];

  // getData() async {
  //   var userName = FirebaseFirestore.instance.collection("users");
  //   await userName.doc().get().then((value) {
  //     print(value.data()!['name']);
  //     setState(() {
  //       tareq = value.data()!['name'].toString();
  //     });
  //   });
  // }
  // Stream<List<StudentsReservation>> readDoc() {
  //   final currentUser = FirebaseAuth.instance.currentUser!;
  //    final tareq = FirebaseFirestore.instance.collection('doctors').where('name').snapshots().map(
  //           (snapshot) =>
  //           snapshot.docs
  //               .map((doc) => StudentsReservation.fromJson(doc.data()))
  //               .toList());
  //    print(tareq);
  //   return tareq;
  // }

  // final CollectionReference _collectionRef =
  //     FirebaseFirestore.instance.collection('users');
  //
  // Future<List> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc['id']).toList();
  //   allData.sort();
  //   for (int i = 0; i < allData.length; i++) {
  //     setState(() {
  //       newDoc = allData.map((e) => e).toList();
  //     });
  //   }
  //   return newDoc;
  // }

  // FirebaseMessaging notification = FirebaseMessaging.instance;
  //
  // getNotifi() async{
  //   NotificationSettings settings = await notification.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   print('User granted permission: ${settings.authorizationStatus}');
  // }

  //
  // @override
  // void initState() {
  //   getData();
  //   // getNotifi();
  //   // readDoc();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        listTile(),
        listTile(),
      ]),
    );
  }

  Widget listTile() {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text("HI"),
      onTap: () {
        setState(() {
          //getTime();
          addTime();
          //countHours();
        });
      },
    );
  }

  String tareq = "tareq";

  List available = [
    '11:30 - 10:40',
    '11:40 - 11:50',
    '11:50 - 12:00',
    '12:00 - 01:10',
    '12:10 - 02:20',
    '12:20 - 03:30',
  ];

  List booked = [
    '11:30 - 11:40',
    '12:00 - 12:30',
  ];
  int? hours;
  int? minutes;
  String? hour;
  String? minute;
  String? oldHour;
  String? newHour;
  // var format = DateFormat("HH:mm");
  // var one = format.parse("10:40");
  // var two = format.parse("18:20");
  // print("${two.difference(one)}"); // prints 7:40

  countHours(int t) {
    var format = DateFormat("HH:mm");
    int startHour = int.parse(doctorOfficeHours.substring(0, 2));
    int endHour = int.parse(doctorOfficeHours.substring(8, 10));
    int endMin = int.parse(doctorOfficeHours.substring(11, 13));
    var oneTime = doctorOfficeHours.substring(0, 5);
    var secTime = doctorOfficeHours.substring(8, 13);
    if (startHour > endHour) {
      endHour = endHour + 12;
      secTime = "${endHour}:$endMin";
    }
    var one = format.parse(oneTime);
    var two = format.parse(secTime);
    var min = two.difference(one).inMinutes / t;
    var intMin = min.floor();

    // print("${two.difference(one).inMinutes}"); // prints 7:40
    // print(two.difference(one).inMinutes / 5);
    return intMin;
  }

  // int countHours() {
  //   int startHour = int.parse(doctorOfficeHours.substring(0, 2));
  //   int endHour = int.parse(doctorOfficeHours.substring(8, 10));
  //   int startMin = int.parse(doctorOfficeHours.substring(3, 5));
  //   int endMin = int.parse(doctorOfficeHours.substring(11, 13));
  //   int hourCounter = 0;
  //   int minCounter = 0;
  //   // print(startHour);
  //   // print(startMin);
  //   //print(endHour);
  //   //print(endMin);
  //   //print(counter);
  //
  //   while (startHour != endHour || startMin != endMin) {
  //     if (minCounter == 60) {
  //       minCounter = 0;
  //       hourCounter++;
  //       startHour++;
  //     }
  //
  //     if (endMin == 0) {
  //       minCounter--;
  //       endMin++;
  //     }
  //     if (startMin == 60 && startHour == 12) {
  //       startMin = 1;
  //       minCounter++;
  //       startHour = 1;
  //       hourCounter++;
  //     }
  //     if (startMin > endMin && startMin < 60) {
  //       startMin++;
  //       minCounter++;
  //     } else if (startMin > endMin && startMin == 60) {
  //       startMin = 1;
  //       minCounter++;
  //     } else {
  //       startMin++;
  //       minCounter++;
  //     }
  //   }
  //   if (minCounter % 60 == 0) {
  //     minCounter = 0;
  //   }
  //   // print('hour: $hourCounter');
  //   // print('min: $minCounter');
  //   int totalMinutes = hourCounter * 60 + minCounter;
  //   //print('$totalMinutes');
  //   return totalMinutes;
  // }

  int makeHour(int hour) {
    if (hour < 12) {
      hour = hour + 1;
      return hour;
    } else {
      hour = 1;
      return hour;
    }
  }

  List available2 = [
    '09:00 - 12:00',
    // '11:40 - 05:55',
    // '11:50 - 06:05',
    // '12:00 - 07:15',
    // '12:10 - 08:25',
    // '12:20 - 09:35',
  ];
  String doctorOfficeHours = '09:30 - 09:40';
  List notAvailable = [];
  List notAvailable2 = [];
  List notAvailable3 = [];

  addTime() {
    int t = 30;
    int fo = countHours(t);
    //print(fo);
    for (int i = 0; i < fo; i++) {
      String startHour1 = doctorOfficeHours.toString().substring(0, 2);
      String startMin1 = doctorOfficeHours.toString().substring(3, 5);
      hour = doctorOfficeHours.toString().substring(0, 2);
      minute = doctorOfficeHours.toString().substring(3, 5);
      hours = int.parse(doctorOfficeHours.toString().substring(0, 2));
      minutes = int.parse(doctorOfficeHours.toString().substring(3, 5));
      oldHour = "$startHour1:$startMin1 - ";
      //print(oldHour);
      notAvailable.add(doctorOfficeHours);
      //print(notAvailable);
      switch (t) {
        case 5:
          if (minutes! >= 0 && minutes! < 55) {
            minutes = (minutes! + 5);
            minute = minutes.toString().padLeft(2, '0');
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else {
            minute = '00';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          }
        case 10:
          if (minutes! >= 0 && minutes! < 50) {
            minutes = (minutes! + 10);
            minute = minutes.toString().padLeft(2, '0');
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 55) {
            minute = '05';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else {
            minute = '00';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          }
        case 15:
          if (minutes! >= 0 && minutes! < 45) {
            minutes = (minutes! + 15);
            minute = minutes.toString().padLeft(2, '0');
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 50) {
            minute = '05';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 55) {
            minute = '10';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else {
            minute = '00';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          }
        case 20:
          if (minutes! >= 0 && minutes! < 40) {
            minutes = (minutes! + 20);
            minute = minutes.toString().padLeft(2, '0');
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 45) {
            minute = '05';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 50) {
            minute = '10';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 55) {
            minute = '15';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else {
            minute = '00';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          }
        case 25:
          if (minutes! >= 0 && minutes! < 35) {
            minutes = (minutes! + 30);
            minute = minutes.toString().padLeft(2, '0');
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 40) {
            minute = '05';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 45) {
            minute = '10';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 50) {
            minute = '15';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 55) {
            minute = '20';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else {
            minute = '00';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          }
        case 30:
          if (minutes! >= 0 && minutes! < 30) {
            minutes = (minutes! + 25);
            minute = minutes.toString().padLeft(2, '0');
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 35) {
            minute = '05';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 40) {
            minute = '10';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 45) {
            minute = '15';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 50) {
            minute = '20';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else if (minutes == 55) {
            minute = '25';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          } else {
            minute = '00';
            hours = makeHour(hours!);
            hour = hours.toString().padLeft(2, '0');
            newHour = "$hour:$minute";
            doctorOfficeHours = newHour!;
            print(oldHour! + newHour!);
            break;
          }

        // case 30:
        //   // if (fo != 0) {
        //   //   for (int i = 0; i < fo; i++) {
        //   //     print(1);
        //   if (minutes! >= 0 && minutes! < 30) {
        //     minutes = (minutes! + 30);
        //     minute = minutes.toString();
        //     hour = hours.toString().padLeft(2, '0');
        //     newHour = "$hour:$minute";
        //     print(oldHour! + newHour!);
        //     break;
        //   } else if (minutes == 35) {
        //     minute = '05';
        //     hours = makeHour(hours!);
        //     hour = hours.toString().padLeft(2, '0');
        //     newHour = "$hour:$minute";
        //     print(oldHour! + newHour!);
        //     break;
        //   } else if (minutes == 40) {
        //     minute = '10';
        //     hours = makeHour(hours!);
        //     hour = hours.toString().padLeft(2, '0');
        //     newHour = "$hour:$minute";
        //     print(oldHour! + newHour!);
        //     break;
        //   } else if (minutes == 45) {
        //     minute = '15';
        //     hours = makeHour(hours!);
        //     hour = hours.toString().padLeft(2, '0');
        //     newHour = "$hour:$minute";
        //     print(oldHour! + newHour!);
        //     break;
        //   } else if (minutes == 50) {
        //     minute = '20';
        //     hours = makeHour(hours!);
        //     hour = hours.toString().padLeft(2, '0');
        //     newHour = "$hour:$minute";
        //     print(oldHour! + newHour!);
        //     break;
        //   } else if (minutes == 55) {
        //     minute = '25';
        //     hours = makeHour(hours!);
        //     hour = hours.toString().padLeft(2, '0');
        //     newHour = "$hour:$minute";
        //     print(oldHour! + newHour!);
        //     break;
        //   } else {
        //     minute = '00';
        //     hours = makeHour(hours!);
        //     hour = hours.toString().padLeft(2, '0');
        //     newHour = "$hour:$minute";
        //     print(oldHour! + newHour!);
        //     break;
        //   }
        //   }
        // } else {
        //   print('No reservation available');
        //   return 'No Reservations available';
        // }
        default:
          int total = countHours(t);
          total = (total / 30).floor();
          for (int i = 0; i < total; i++) {
            notAvailable.add(oldHour! + newHour!);
            oldHour = oldHour! + newHour!;
          }
          print(notAvailable);
          break;
      }
    }
  }
}
