import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/Select_service_edit.dart';
import '../widgets/user_class.dart';

class DeleteService extends StatefulWidget {
  const DeleteService({Key? key, void function}) : super(key: key);

  @override
  State<DeleteService> createState() => _DeleteService();
}

class _DeleteService extends State<DeleteService> {
  @override
  Widget build(BuildContext context) {
    // String selectedService =
    //     Provider.of<ReservationInfo>(context).selectedService;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff141E27),
        title: const Text('My Services'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SetEmpService>>(
        stream: deleteService(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(12.0),
              children: [...users.map(buildListTile).toList()],
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

  Stream<List<SetEmpService>> deleteService() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('Service')
        .where("id", isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SetEmpService.fromJson(doc.data()))
            .toList());
  }

  Widget buildListTile(SetEmpService user) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text("${user.Duration.substring(0, 2)} min"),
          ),
          title: Text(user.Service),
          subtitle: Text('days : ${user.days}\nOffice hour: ${user.Time}'),
          trailing: const Icon(Icons.arrow_forward_ios),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          onTap: () {
            print(FirebaseFirestore.instance
                .collection('Service')
                .doc('user.uid')
                .get()
                .then((value) => print(value)));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeleteSelectService(
                  serviceName: user.Service,
                  days: user.days,
                  time: user.Time,
                  duration: user.Duration,
                  uid: user.id,
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          tileColor: Colors.grey.shade300,
        ),
      );
}
