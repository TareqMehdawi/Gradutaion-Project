import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/class.dart';
import 'package:graduation_project/widgets/user_class.dart';

class ReservationInfo extends ChangeNotifier {
  String selectedService;
  String selectedEmployee;
  String selectedEmployeeId;

  ReservationInfo(
      {this.selectedService = 'Service', this.selectedEmployee = 'Employee',this.selectedEmployeeId = '1T5Ra03laoewLhQ3zAeEZB4GaNz2'});
}

enum employee { doctor, registration }

int whichEmployee = 0;

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  int currentStep = 0;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  List<Message> messages = [];
  final currentUser = FirebaseAuth.instance.currentUser!;
  String studentName = '';

  getData() async {
    var userName = FirebaseFirestore.instance.collection("student");
    await userName.doc(currentUser.uid).get().then((value) {
      setState(() {
        studentName = value.data()!['name'].toString();
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  // final CollectionReference _collectionRef =
  // FirebaseFirestore.instance.collection('doctors');
  //
  // Future<List> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc['name']).toList();
  //   allData.sort();
  //   for (int i = 0; i < allData.length; i++) {
  //     setState(() {
  //       newDoc = allData.map((e) => e).toList();
  //     });
  //   }
  //   return newDoc;
  // }

  @override
  Widget build(BuildContext context) {
    // var hours = time.hourOfPeriod.toString().padLeft(2, '0');
    // final minutes = time.minute.toString().padLeft(2, '0');
    // String selectedService =
    //     Provider.of<ReservationInfo>(context).selectedService;
    // String selectedEmployee =
    //     Provider.of<ReservationInfo>(context).selectedEmployee;
    // String selectedEmpID =
    //     Provider.of<ReservationInfo>(context).selectedEmployeeId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff141E27),
        title: const Text('Reservation'),
        centerTitle: true,
      ),
      body: Stepper(steps: const [],
      //   currentStep: currentStep,
      //   onStepTapped: (index) {
      //     setState(() {
      //       currentStep = index;
      //     });
      //   },
      //   onStepContinue: () {
      //     if (currentStep != 3) {
      //       setState(() {
      //         currentStep++;
      //       });
      //     } else {
      //       setReservation(
      //         empName: selectedEmployee,
      //         empId: selectedEmpID,
      //         service: selectedService,
      //         people: 10,
      //         currentTime: "10:15",
      //         currentDate: '${date.month}/${date.day}',
      //         studentName: studentName,
      //       );
      //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationDrawer()));
      //     }
      //   },
      //   onStepCancel: () {
      //     if (currentStep != 0) {
      //       setState(() {
      //         currentStep--;
      //       });
      //     }
      //   },
      //   steps: [
      //     Step(
      //       isActive: currentStep >= 0,
      //       content: Row(
      //         children: [
      //           Expanded(
      //             flex: 2,
      //             child: Padding(
      //               padding: const EdgeInsets.only(right: 8.0),
      //               child: FittedBox(
      //                 fit: BoxFit.scaleDown,
      //                 alignment: Alignment.centerLeft,
      //                 child: Text(
      //                   selectedEmployee,
      //                   style: const TextStyle(fontSize: 20),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Expanded(
      //             flex: 1,
      //             child: ElevatedButton(
      //               onPressed: () async {
      //                  await showSearch(
      //                   context: context,
      //                   delegate: EmployeeSearchDelegate(),
      //
      //                 //      final employee =  await showSearch(
      //                 //  context: context,
      //                 //  delegate: EmployeeSearchDelegate(),
      //                 // );
      //                 // setState(() {
      //                 // print(selectedEmployeee);
      //                 // selectedEmployeee = employee;
      //                 // print(selectedEmployeee);
      //                 // });
      //                 );
      //               },
      //               child: const Icon(
      //                 Icons.search,
      //                 size: 30,
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       title: Text(
      //         'Choose who you want to meet:',
      //         style:
      //             currentStep == 0 ? const TextStyle(color: Colors.blue) : null,
      //       ),
      //     ),
      //     Step(
      //       isActive: currentStep >= 1,
      //       content: Row(
      //         children: [
      //           Expanded(
      //             flex: 2,
      //             child: Padding(
      //               padding: const EdgeInsets.only(right: 8.0),
      //               child: FittedBox(
      //                 fit: BoxFit.scaleDown,
      //                 alignment: Alignment.centerLeft,
      //                 child: Text(
      //                   selectedService,
      //                   style: const TextStyle(fontSize: 20),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Expanded(
      //             flex: 1,
      //             child: ElevatedButton(
      //               onPressed: () async {
      //                 await showSearch(
      //                   context: context,
      //                   delegate: ServicesSearchDelegate(),
      //                 );
      //               },
      //               child: const Icon(
      //                 Icons.search,
      //                 size: 30,
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       title: Text(
      //         'Choose a service:',
      //         style:
      //             currentStep == 1 ? const TextStyle(color: Colors.blue) : null,
      //       ),
      //     ),
      //     Step(
      //       isActive: currentStep >= 2,
      //       content: Row(
      //         children: [
      //           Expanded(
      //             flex: 1,
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //               child: Text(
      //                 '${date.year}/${date.month}/${date.day}',
      //                 style: const TextStyle(fontSize: 20),
      //               ),
      //             ),
      //           ),
      //           Expanded(
      //               flex: 1,
      //               child: ElevatedButton(
      //                 onPressed: () async {
      //                   DateTime? newDate = await showDatePicker(
      //                     context: context,
      //                     initialDate: date,
      //                     firstDate: DateTime.now().subtract(
      //                       const Duration(days: 0),
      //                     ),
      //                     lastDate: DateTime.now().add(
      //                       const Duration(days: 7),
      //                     ),
      //                   );
      //                   if (newDate == null) return;
      //
      //                   setState(() {
      //                     date = newDate;
      //                   });
      //                 },
      //                 child: const Text(
      //                   'Select Date',
      //                   style: TextStyle(fontSize: 18),
      //                 ),
      //               )),
      //         ],
      //       ),
      //       title: Text(
      //         'Select Date:',
      //         style:
      //             currentStep == 2 ? const TextStyle(color: Colors.blue) : null,
      //       ),
      //     ),
      //     Step(
      //       isActive: currentStep >= 3,
      //       content: Row(
      //         children: [
      //           Expanded(
      //             flex: 1,
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 40.0),
      //               child: Text(
      //                 '$hours:$minutes',
      //                 style: const TextStyle(fontSize: 20),
      //               ),
      //             ),
      //           ),
      //           Expanded(
      //             flex: 1,
      //             child: ElevatedButton(
      //               onPressed: () async {
      //                 TimeOfDay? newTime = await showTimePicker(
      //                   context: context,
      //                   initialTime: time,
      //                 );
      //                 if (newTime == null) return;
      //                 setState(() {
      //                   time = newTime;
      //                 });
      //               },
      //               child: const Text(
      //                 'Select Time',
      //                 style: TextStyle(fontSize: 18),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       title: Text(
      //         'Choose Time',
      //         style:
      //             currentStep == 3 ? const TextStyle(color: Colors.blue) : null,
      //       ),
      //     ),
      //   ],
      // ),
      ),
    );
  }



  Future setReservation(
      {required String empName,
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
    );
    final json = user.toJson();
    await docUser.set(json);
  }
}
