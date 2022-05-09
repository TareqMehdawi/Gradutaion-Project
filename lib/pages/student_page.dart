import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user_class.dart';
import 'make_reservations.dart';
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
              Provider.of<NavigationProvider>(context, listen: false).changeValue();
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReservationPage(),),);
        },
      ),
      body: StreamBuilder<List<StudentsReservation>>(
        stream: readReservation(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final users = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView(
                      children: users.map(buildListTile).toList(),
                    ),
                  );

          // return ListView.builder(
                //   padding: const EdgeInsets.all(12.0),
                //   itemCount: 5,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 5.0),
                //       child: ListTile(
                //         leading: const Padding(
                //           padding: EdgeInsets.only(top: 10.0),
                //           child: Text('3/16'),
                //         ),
                //         title: Text(name),
                //         subtitle: const Text(
                //             'People in front of you: 5 \nExpected time: 9:45'),
                //         trailing: const Icon(Icons.arrow_forward_ios),
                //         contentPadding: const EdgeInsets.symmetric(
                //             vertical: 15, horizontal: 15),
                //         onTap: () {
                //
                //         },
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10.0),
                //         ),
                //         tileColor: Colors.grey.shade300,
                //       ),
                //     );
                //   },
                // );
          }
          if(snapshot.hasError){
            print(snapshot.error);
            return const Center(
              child: Text("Fuck Ayasrah"),
            );
          }
          else{
            return const Center(
              child: Text("Fuck you"),
            );
          }
        }
      ),
    );
  }

  Widget buildListTile(StudentsReservation user) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: ListTile(
      leading:  Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(user.date),
      ),
      title: Text(user.doctor),
      subtitle:  Text(
          'people in front of you: ${user.people} \nExpected time: ${user.time}'),
      trailing: const Icon(Icons.arrow_forward_ios),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 15, horizontal: 15),
      onTap: () {

      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      tileColor: Colors.grey.shade300,
    ),
  );

  Stream<List<StudentsReservation>> readReservation() =>
      FirebaseFirestore.instance.collection('student').snapshots().map(
              (snapshot) => snapshot.docs
              .map((doc) => StudentsReservation.fromJson(doc.data()))
              .toList());

}