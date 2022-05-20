import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/make_service.dart';
import 'package:provider/provider.dart';
import '../widgets/user_class.dart';
import 'navigation_drawer.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key, void function}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    // String selectedService =
    //     Provider.of<ReservationInfo>(context).selectedService;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff141E27),
        title: const Text('Employee'),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Provider.of<NavigationProvider>(context, listen: false)
                  .changeValue();
            });
          },
          icon: const Icon(Icons.menu),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff141E27),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ServicePage(),
            ),
          );
        },
      ),
      body: StreamBuilder<List<StudentsReservation>>(
        stream: readReservation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(12.0),
              children: [ ...users.map(buildListTile).toList()],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Loading1"),
            );
          } else {
            return const Center(
              child: Text("Loading"),
            );
          }
        },
      ),
    );
  }

  Stream<List<StudentsReservation>> readReservation() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('reservation')
        .where("empId", isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => StudentsReservation.fromJson(doc.data()))
        .toList());
  }
  Widget buildListTile(StudentsReservation user) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: ListTile(
      leading:  Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(user.date),
      ),
      title: Text(user.student),
      subtitle:  Text(
          'Service: ${user.service} \nExpected time: ${user.time}'),
      trailing: const Icon(Icons.arrow_forward_ios),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 15, horizontal: 15),
      onTap: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      tileColor: Colors.grey.shade300,
    ),
  );
}