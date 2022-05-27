import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

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

enum FilterStatus { Upcoming, Complete, Cancel }

List<Map> schedules = [
  {
    'img': 'assets/doctor01.jpeg',
    'doctorName': 'Dr. Anastasya Syahid',
    'doctorTitle': 'Dental Specialist',
    'reservedDate': 'Monday, Aug 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Upcoming
  }
];

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
    // List<Map> filteredSchedules = schedules.where((var schedule) {
    //   return schedule['status'] == status;
    // }).toList();

    return const Scaffold(
        // appBar: AppBar(),
        // body: ListView(children: [
        //   listTile(),
        //   listTile(),
        // ]),
        // backgroundColor: Theme.of(context).primaryColor,
        // primary: false,
        // appBar: PreferredSize(
        //   preferredSize: Size(100, 100),
        //   child: SafeArea(
        //       child: Container(
        //         color: Theme.of(context).primaryColor,
        //         width: MediaQuery.of(context).size.width,
        //         // Set Appbar wave height
        //         child: Container(
        //           height: 80,
        //           color: Theme.of(context).scaffoldBackgroundColor,
        //           child: Container(
        //               color: Colors.white,
        //               child: Stack(
        //                 children: <Widget>[
        //                   RotatedBox(
        //                       quarterTurns: 2,
        //                       child: WaveWidget(
        //                         config: CustomConfig(
        //                           colors: [Theme.of(context).primaryColor],
        //                           durations: [22000],
        //                           heightPercentages: [-0.1],
        //                         ),
        //                         size: Size(double.infinity, double.infinity),
        //                         waveAmplitude: 1,
        //                       )),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       Builder(
        //                         builder: (context) => IconButton(
        //                           onPressed: () {
        //                             setState(() {
        //                               //Provider.of<NavigationProvider>(context, listen: false)
        //                                   //.changeValue();
        //                             });
        //                           },
        //                           icon: const Icon(Icons.menu),
        //                         )
        //                       ),
        //                       Padding(
        //                           padding: EdgeInsets.only(left: 50),
        //                           child: Text(
        //                             "Employee page",
        //                             style: TextStyle(fontSize: 20, color: Colors.white),
        //                           )),
        //                     ],
        //                   ),
        //                 ],
        //               )),
        //         ),
        //       )),
        // ),
        // body: ListView(
        //   children:[
        //     Expanded(
        //       child:  Card(
        //             child: Padding(
        //               padding: EdgeInsets.all(15),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.stretch,
        //                 children: [
        //                   Row(
        //                     children: [
        //                       CircleAvatar(
        //                         backgroundImage: AssetImage('assets/images/a.png'),
        //                       ),
        //                       SizedBox(
        //                         width: 10,
        //                       ),
        //                       Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           Text(
        //                             "_schedule['doctorName']",
        //                             style: TextStyle(
        //                               color: Color(MyColors.header01),
        //                               fontWeight: FontWeight.w700,
        //                             ),
        //                           ),
        //                           SizedBox(
        //                             height: 5,
        //                           ),
        //                           Text(
        //                             "_schedule['doctorTitle']",
        //                             style: TextStyle(
        //                               color: Color(MyColors.grey02),
        //                               fontSize: 12,
        //                               fontWeight: FontWeight.w600,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ],
        //                   ),
        //                   SizedBox(
        //                     height: 15,
        //                   ),
        //                   DateTimeCard(),
        //                   SizedBox(
        //                     height: 15,
        //                   ),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Expanded(
        //                         child: OutlinedButton(
        //                           child: Text('Cancel'),
        //                           onPressed: () {},
        //                         ),
        //                       ),
        //                       SizedBox(
        //                         width: 20,
        //                       ),
        //                       Expanded(
        //                         child: ElevatedButton(
        //                           child: Text('Reschedule'),
        //                           onPressed: () => {},
        //                         ),
        //                       )
        //                     ],
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ),
        //     ),
        //     Column(
        //       children: [
        //         Container(
        //           width: double.infinity,
        //           decoration: BoxDecoration(
        //             color: Color(MyColors.primary),
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //           child: Material(
        //             color: Colors.transparent,
        //             child: InkWell(
        //               //onTap: onTap,
        //               child: Padding(
        //                 padding: const EdgeInsets.all(20),
        //                 child: Column(
        //                   children: [
        //                     Row(
        //                       children: [
        //                         CircleAvatar(
        //                           backgroundImage: AssetImage('assets/doctor01.jpeg'),
        //                         ),
        //                         SizedBox(
        //                           width: 10,
        //                         ),
        //                         Column(
        //                           mainAxisAlignment: MainAxisAlignment.center,
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text('Dr.Muhammed Syahid',
        //                                 style: TextStyle(color: Colors.white)),
        //                             SizedBox(
        //                               height: 2,
        //                             ),
        //                             Text(
        //                               'Dental Specialist',
        //                               style: TextStyle(color: Color(MyColors.text01)),
        //                             ),
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                     SizedBox(
        //                       height: 20,
        //                     ),
        //                     ScheduleCard(),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //         Container(
        //           margin: EdgeInsets.symmetric(horizontal: 20),
        //           width: double.infinity,
        //           height: 10,
        //           decoration: BoxDecoration(
        //             color: Color(MyColors.bg02),
        //             borderRadius: BorderRadius.only(
        //               bottomRight: Radius.circular(10),
        //               bottomLeft: Radius.circular(10),
        //             ),
        //           ),
        //         ),
        //         Container(
        //           margin: EdgeInsets.symmetric(horizontal: 40),
        //           width: double.infinity,
        //           height: 10,
        //           decoration: BoxDecoration(
        //             color: Color(MyColors.bg03),
        //             borderRadius: BorderRadius.only(
        //               bottomRight: Radius.circular(10),
        //               bottomLeft: Radius.circular(10),
        //             ),
        //           ),
        //         ),
        //       ],
        //     )
        //   ]
        // ),
        );
  }

  Widget listTile() {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text("HI"),
      onTap: () {
        setState(() {
          //getTime();
          //addTime();
          //countHours();
        });
      },
    );
  }

  // String tareq = "tareq";
  //
  // List available = [
  //   '11:30 - 10:40',
  //   '11:40 - 11:50',
  //   '11:50 - 12:00',
  //   '12:00 - 01:10',
  //   '12:10 - 02:20',
  //   '12:20 - 03:30',
  // ];
  //
  // List booked = [
  //   '11:30 - 11:40',
  //   '12:00 - 12:30',
  // ];
  // int? hours;
  // int? minutes;
  // String? hour;
  // String? minute;
  // String? oldHour;
  // String? newHour;
  // // var format = DateFormat("HH:mm");
  // // var one = format.parse("10:40");
  // // var two = format.parse("18:20");
  // // print("${two.difference(one)}"); // prints 7:40
  //
  // countHours(int t) {
  //   var format = DateFormat("HH:mm");
  //   int startHour = int.parse(doctorOfficeHours.substring(0, 2));
  //   int endHour = int.parse(doctorOfficeHours.substring(8, 10));
  //   int endMin = int.parse(doctorOfficeHours.substring(11, 13));
  //   var oneTime = doctorOfficeHours.substring(0, 5);
  //   var secTime = doctorOfficeHours.substring(8, 13);
  //   if (startHour > endHour) {
  //     endHour = endHour + 12;
  //     secTime = "${endHour}:$endMin";
  //   }
  //   var one = format.parse(oneTime);
  //   var two = format.parse(secTime);
  //   var min = two.difference(one).inMinutes / t;
  //   var intMin = min.floor();
  //
  //   // print("${two.difference(one).inMinutes}"); // prints 7:40
  //   // print(two.difference(one).inMinutes / 5);
  //   return intMin;
  // }
  //
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
  //
  // int makeHour(int hour) {
  //   if (hour < 12) {
  //     hour = hour + 1;
  //     return hour;
  //   } else {
  //     hour = 1;
  //     return hour;
  //   }
  // }
  //
  // List available2 = [
  //   '09:00 - 12:00',
  //   // '11:40 - 05:55',
  //   // '11:50 - 06:05',
  //   // '12:00 - 07:15',
  //   // '12:10 - 08:25',
  //   // '12:20 - 09:35',
  // ];
  // String doctorOfficeHours = '09:30 - 09:40';
  // List notAvailable = [];
  // List notAvailable2 = [];
  // List notAvailable3 = [];
  //
  // addTime() {
  //   int t = 30;
  //   int fo = countHours(t);
  //   //print(fo);
  //   for (int i = 0; i < fo; i++) {
  //     String startHour1 = doctorOfficeHours.toString().substring(0, 2);
  //     String startMin1 = doctorOfficeHours.toString().substring(3, 5);
  //     hour = doctorOfficeHours.toString().substring(0, 2);
  //     minute = doctorOfficeHours.toString().substring(3, 5);
  //     hours = int.parse(doctorOfficeHours.toString().substring(0, 2));
  //     minutes = int.parse(doctorOfficeHours.toString().substring(3, 5));
  //     oldHour = "$startHour1:$startMin1 - ";
  //     //print(oldHour);
  //     notAvailable.add(doctorOfficeHours);
  //     //print(notAvailable);
  //     switch (t) {
  //       case 5:
  //         if (minutes! >= 0 && minutes! < 55) {
  //           minutes = (minutes! + 5);
  //           minute = minutes.toString().padLeft(2, '0');
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else {
  //           minute = '00';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         }
  //       case 10:
  //         if (minutes! >= 0 && minutes! < 50) {
  //           minutes = (minutes! + 10);
  //           minute = minutes.toString().padLeft(2, '0');
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 55) {
  //           minute = '05';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else {
  //           minute = '00';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         }
  //       case 15:
  //         if (minutes! >= 0 && minutes! < 45) {
  //           minutes = (minutes! + 15);
  //           minute = minutes.toString().padLeft(2, '0');
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 50) {
  //           minute = '05';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 55) {
  //           minute = '10';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else {
  //           minute = '00';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         }
  //       case 20:
  //         if (minutes! >= 0 && minutes! < 40) {
  //           minutes = (minutes! + 20);
  //           minute = minutes.toString().padLeft(2, '0');
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 45) {
  //           minute = '05';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 50) {
  //           minute = '10';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 55) {
  //           minute = '15';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else {
  //           minute = '00';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         }
  //       case 25:
  //         if (minutes! >= 0 && minutes! < 35) {
  //           minutes = (minutes! + 30);
  //           minute = minutes.toString().padLeft(2, '0');
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 40) {
  //           minute = '05';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 45) {
  //           minute = '10';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 50) {
  //           minute = '15';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 55) {
  //           minute = '20';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else {
  //           minute = '00';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         }
  //       case 30:
  //         if (minutes! >= 0 && minutes! < 30) {
  //           minutes = (minutes! + 25);
  //           minute = minutes.toString().padLeft(2, '0');
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 35) {
  //           minute = '05';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 40) {
  //           minute = '10';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 45) {
  //           minute = '15';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 50) {
  //           minute = '20';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else if (minutes == 55) {
  //           minute = '25';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         } else {
  //           minute = '00';
  //           hours = makeHour(hours!);
  //           hour = hours.toString().padLeft(2, '0');
  //           newHour = "$hour:$minute";
  //           doctorOfficeHours = newHour!;
  //           print(oldHour! + newHour!);
  //           break;
  //         }
  //
  //       // case 30:
  //       //   // if (fo != 0) {
  //       //   //   for (int i = 0; i < fo; i++) {
  //       //   //     print(1);
  //       //   if (minutes! >= 0 && minutes! < 30) {
  //       //     minutes = (minutes! + 30);
  //       //     minute = minutes.toString();
  //       //     hour = hours.toString().padLeft(2, '0');
  //       //     newHour = "$hour:$minute";
  //       //     print(oldHour! + newHour!);
  //       //     break;
  //       //   } else if (minutes == 35) {
  //       //     minute = '05';
  //       //     hours = makeHour(hours!);
  //       //     hour = hours.toString().padLeft(2, '0');
  //       //     newHour = "$hour:$minute";
  //       //     print(oldHour! + newHour!);
  //       //     break;
  //       //   } else if (minutes == 40) {
  //       //     minute = '10';
  //       //     hours = makeHour(hours!);
  //       //     hour = hours.toString().padLeft(2, '0');
  //       //     newHour = "$hour:$minute";
  //       //     print(oldHour! + newHour!);
  //       //     break;
  //       //   } else if (minutes == 45) {
  //       //     minute = '15';
  //       //     hours = makeHour(hours!);
  //       //     hour = hours.toString().padLeft(2, '0');
  //       //     newHour = "$hour:$minute";
  //       //     print(oldHour! + newHour!);
  //       //     break;
  //       //   } else if (minutes == 50) {
  //       //     minute = '20';
  //       //     hours = makeHour(hours!);
  //       //     hour = hours.toString().padLeft(2, '0');
  //       //     newHour = "$hour:$minute";
  //       //     print(oldHour! + newHour!);
  //       //     break;
  //       //   } else if (minutes == 55) {
  //       //     minute = '25';
  //       //     hours = makeHour(hours!);
  //       //     hour = hours.toString().padLeft(2, '0');
  //       //     newHour = "$hour:$minute";
  //       //     print(oldHour! + newHour!);
  //       //     break;
  //       //   } else {
  //       //     minute = '00';
  //       //     hours = makeHour(hours!);
  //       //     hour = hours.toString().padLeft(2, '0');
  //       //     newHour = "$hour:$minute";
  //       //     print(oldHour! + newHour!);
  //       //     break;
  //       //   }
  //       //   }
  //       // } else {
  //       //   print('No reservation available');
  //       //   return 'No Reservations available';
  //       // }
  //       default:
  //         int total = countHours(t);
  //         total = (total / 30).floor();
  //         for (int i = 0; i < total; i++) {
  //           notAvailable.add(oldHour! + newHour!);
  //           oldHour = oldHour! + newHour!;
  //         }
  //         print(notAvailable);
  //         break;
  //     }
  // }
  //}
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg01),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Mon, July 29',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              '11:00 ~ 12:10',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg03),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Color(MyColors.primary),
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Mon, July 29',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.access_alarm,
                color: Color(MyColors.primary),
                size: 17,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '11:00 ~ 12:10',
                style: TextStyle(
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
// Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//     child: Align(
//         alignment: Alignment.bottomCenter,
//         child: SizedBox(
//           width: 320,
//           height: 50,
//           // child: Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           //   children: [
//           // ElevatedButton(
//           //   style: ElevatedButton.styleFrom(
//           //       maximumSize: const Size.fromHeight(40),
//           //       primary: Colors.black),
//           //   child: FittedBox(
//           //     child: Text(
//           //       startTime == null
//           //           ? "Select Start Time"
//           //           : "$startTime",
//           //       style: const TextStyle(
//           //           fontSize: 15, color: Colors.white),
//           //     ),
//           //   ),
//           //   onPressed: () async {
//           //     showCupertinoModalPopup(
//           //         context: context,
//           //         builder: (BuildContext builder) {
//           //           return Container(
//           //             height: MediaQuery.of(context)
//           //                     .copyWith()
//           //                     .size
//           //                     .height *
//           //                 0.25,
//           //             color: Colors.white,
//           //             child: CupertinoDatePicker(
//           //               mode: CupertinoDatePickerMode.time,
//           //               onDateTimeChanged: (value) {
//           //                 setState(() {
//           //                   if (value != startTime) {
//           //                     startTime =
//           //                         '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}';
//           //                   }
//           //                   int t = value.hour;
//           //                   if (t > 12) {
//           //                     t = t - 12;
//           //                     startTime =
//           //                         '${t.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}';
//           //                   }
//           //                 });
//           //               },
//           //               initialDateTime: DateTime.now(),
//           //             ),
//           //           );
//           //         });
//           //   },
//           // ),
//           // ElevatedButton(
//           //   style: ElevatedButton.styleFrom(
//           //       maximumSize: const Size.fromHeight(40),
//           //       primary: Colors.black),
//           //   child: FittedBox(
//           //     child: Text(
//           //       endTime == null ? "Select End Time" : "$endTime",
//           //       style: const TextStyle(
//           //           fontSize: 15, color: Colors.white),
//           //     ),
//           //   ),
//           //   onPressed: () async {
//           //     showCupertinoModalPopup(
//           //         context: context,
//           //         builder: (BuildContext builder) {
//           //           return Container(
//           //             height: MediaQuery.of(context)
//           //                     .copyWith()
//           //                     .size
//           //                     .height *
//           //                 0.25,
//           //             color: Colors.white,
//           //             child: CupertinoDatePicker(
//           //               mode: CupertinoDatePickerMode.time,
//           //               onDateTimeChanged: (value) {
//           //                 setState(() {
//           //                   if (value != endTime) {
//           //                     endTime =
//           //                         '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}';
//           //                   }
//           //                   int t = value.hour;
//           //                   if (t > 12) {
//           //                     t = t - 12;
//           //                     endTime =
//           //                         '${t.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}';
//           //                   }
//           //                 });
//           //               },
//           //               initialDateTime: DateTime.now(),
//           //             ),
//           //           );
//           //         });
//           //   },
//           // ),
//           //   ],
//           // ),
//         ))),
// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//   child: Center(
//     child: DropdownButtonHideUnderline(
//       child: DropdownButton2(
//         isExpanded: true,
//         hint: Row(
//           children: const [
//             Icon(
//               Icons.list,
//               size: 16,
//               color: Colors.yellow,
//             ),
//             SizedBox(
//               width: 4,
//             ),
//             Expanded(
//               child: Text(
//                 'Select Time',
//                 style: TextStyle(
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
