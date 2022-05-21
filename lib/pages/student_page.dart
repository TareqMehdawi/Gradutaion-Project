import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/search_delegate_employee.dart';
import '../widgets/user_class.dart';
import 'navigation_drawer.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key, void function}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
//    String selectedService = Provider.of<ReservationInfo>(context).selectedService;
    //String name = selectedService;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff141E27),
        title: const Text('Appointment'),
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
        onPressed: () async {
          buildBottomSheet();
          // await showSearch(
          //     context: context,
          //     delegate: EmployeeSearchDelegate(),
          // );
        },
      ),
      body: StreamBuilder<List<StudentsReservation>>(
          stream: readReservation(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  children: users.map(buildListTile).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Loading"),
              );
            } else {
              return const Center(
                child: Text("Loading"),
              );
            }
          }),
    );
  }

  Widget buildListTile(StudentsReservation user) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(user.date),
          ),
          title: Text(user.service),
          subtitle: Text(
              'people in front of you: ${user.people} \nExpected time: ${user.time}'),
          trailing: const Icon(Icons.arrow_forward_ios),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          onTap: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          tileColor: Colors.grey.shade300,
        ),
      );

  Stream<List<StudentsReservation>> readReservation() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('reservation')
        .where("id", isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentsReservation.fromJson(doc.data()))
            .toList());
  }

  Future buildBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
          child: ListView(
            children: [
              const Center(
                child: Text(
                  "Choose who you want to meet:",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  loginButton(title: 'Doctor',function: () async{
                    Navigator.pop(context);
                    await showSearch(
                      context: context,
                      delegate: EmployeeSearchDelegate(type: 'doctor'),
                    );
                  },),
                  loginButton(title: 'Registration',function: () async{
                    Navigator.pop(context);
                    await showSearch(
                      context: context,
                      delegate: EmployeeSearchDelegate(type: 'registration'),
                    );
                  },),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget loginButton({required String title,required VoidCallback function}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * .35,
            MediaQuery.of(context).size.height * .06),
        side: const BorderSide(width: 1, color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: function,
      child: Text(
        title,
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

}
