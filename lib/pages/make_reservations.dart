import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/class.dart';
import 'package:graduation_project/widgets/search_delegate_services.dart';
import 'package:graduation_project/widgets/user_class.dart';
import '../widgets/search_delegate_employee.dart';
import 'package:provider/provider.dart';

class ReservationInfo extends ChangeNotifier {
  String selectedService;
  String selectedEmployee;

  ReservationInfo(
      {this.selectedService = 'Service', this.selectedEmployee = 'Employee'});
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
  // var newDoc= [];
  //
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
    var hours = time.hourOfPeriod.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    String selectedService =
        Provider.of<ReservationInfo>(context).selectedService;
    String selectedEmployee =
        Provider.of<ReservationInfo>(context).selectedEmployee;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff141E27),
        title: const Text('Reservation'),
        centerTitle: true,
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepTapped: (index) {
          if (index == 0) {
            setState(() {
              Provider.of<ReservationInfo>(context, listen: false)
                  .selectedService = "Service";
              Provider.of<ReservationInfo>(context, listen: false)
                  .selectedEmployee = "Employee";
            });
          }
          setState(() {
            currentStep = index;
          });
        },
        onStepContinue: () {
          if (currentStep != 4) {
            setState(() {
              currentStep++;
            });
          }
          else {
             setReservation(
                doctor: selectedEmployee,
                service: selectedService,
                people: 10,
                currentTime: "10:15",
                currentDate: '${date.month}/${date.day}',
              );
            Navigator.pop(context);
          }
        },
        onStepCancel: () {
          if (currentStep != 0) {
            setState(() {
              currentStep--;
            });
          }
          if (currentStep == 0) {
            setState(() {
              selectedService = 'Service';
              selectedEmployee = 'Employee';
            });
          }
        },
        steps: [
          Step(
            isActive: currentStep >= 0,
            content: Column(
              children: [
                customRadioButton('Doctor', 1),
                customRadioButton('Registration', 2),
              ],
            ),
            title: Text(
              'Choose one of the following:',
              style:
                  currentStep == 0 ? const TextStyle(color: Colors.blue) : null,
            ),
          ),
          Step(
            isActive: currentStep >= 1,
            content: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedEmployee,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      final employeeName = await showSearch(
                        context: context,
                        delegate: EmployeeSearchDelegate(),
                      );
                      setState(() {
                        Provider.of<ReservationInfo>(context, listen: false)
                            .selectedEmployee = employeeName;
                      });
                    },
                    child: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              'Choose who you want to meet:',
              style:
                  currentStep == 1 ? const TextStyle(color: Colors.blue) : null,
            ),
          ),
          Step(
            isActive: currentStep >= 2,
            content: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedService,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      final serviceName = await showSearch(
                        context: context,
                        delegate: ServicesSearchDelegate(),
                      );
                      setState(() {
                        Provider.of<ReservationInfo>(context, listen: false)
                            .selectedService = serviceName;
                      });
                    },
                    child: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              'Choose a service:',
              style:
                  currentStep == 2 ? const TextStyle(color: Colors.blue) : null,
            ),
          ),
          Step(
            isActive: currentStep >= 3,
            content: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '${date.year}/${date.month}/${date.day}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 0),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 7),
                          ),
                        );
                        if (newDate == null) return;

                        setState(() {
                          date = newDate;
                        });
                      },
                      child: const Text(
                        'Select Date',
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
              ],
            ),
            title: Text(
              'Select Date:',
              style:
                  currentStep == 3 ? const TextStyle(color: Colors.blue) : null,
            ),
          ),
          Step(
            isActive: currentStep >= 4,
            content: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      '$hours:$minutes',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: time,
                      );
                      if (newTime == null) return;
                      setState(() {
                        time = newTime;
                      });
                    },
                    child: const Text(
                      'Select Time',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              'Choose Time',
              style:
                  currentStep == 4 ? const TextStyle(color: Colors.blue) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget customRadioButton(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          whichEmployee = index;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: (whichEmployee == index) ? Colors.blue.shade700 : Colors.black,
        ),
      ),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(
            color:
                (whichEmployee == index) ? Colors.blue.shade700 : Colors.black),
      ),
    );
  }

  Future setReservation(
      {required String doctor,
      required String service,
      required int people,
      required String currentTime,
      required String currentDate,}) async {
    final docUser =
        FirebaseFirestore.instance.collection('student').doc();
    final user = StudentsReservation(
      id: currentUser.uid,
      doctor: doctor,
      service: service,
      people: people,
      time: currentTime,
      date: currentDate,
    );
    final json = user.toJson();
    await docUser.set(json);
  }

}
