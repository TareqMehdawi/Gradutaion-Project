import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/Select_service_edit.dart';
import '../styles/colors.dart';
import '../widgets/user_class.dart';

class MyServices extends StatefulWidget {
  const MyServices({Key? key, void function}) : super(key: key);

  @override
  State<MyServices> createState() => _MyServices();
}

class _MyServices extends State<MyServices> {
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
        stream: reviewService(),
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
  Future deleteService(SetEmpService user) async {
      final docUser2 = await FirebaseFirestore.instance
          .collection('Service')
          .where('Service', isEqualTo: user.Service)
          .where('id', isEqualTo: user.id)
          .get();
      for (var doc in docUser2.docs) {
        await FirebaseFirestore.instance
            .collection('Service')
            .doc(doc.id)
            .delete();
      }
    }



  Stream<List<SetEmpService>> reviewService() {
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
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.Service,
                          style: TextStyle(
                            color: Color(0xff4A71F2),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
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
                            color: Color(0xff4A71F2),
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            user.days.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff4A71F2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_alarm,
                            color: Color(0xff4A71F2),
                            size: 17,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            user.Duration,
                            style: TextStyle(
                              color: Color(0xff4A71F2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        child: Text('Delete'),
                        onPressed: () async {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Warning',
                            desc: 'Are you sure you want to delete this service',
                            btnOkText: "Delete",
                            btnCancelText: 'Cancel',
                            btnCancelOnPress: (){},
                            btnOkOnPress: () {
                              try {
                                deleteService(user);
                                AwesomeDialog(
                                  autoDismiss: false,
                                  context: context,
                                  dialogType: DialogType.SUCCES,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Success',
                                  desc: 'Service deleted successfully',
                                  btnOkText: 'Go back',
                                  btnCancelColor: Colors.black87,
                                  onDissmissCallback: (d) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const MyServices()));
                                  },
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const MyServices()));
                                  },
                                ).show();
                              } on FirebaseAuthException catch(error){
                                AwesomeDialog(
                                  autoDismiss: false,
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Error',
                                  desc: '${error.message}',
                                  btnCancelText: 'Go back',
                                  btnCancelColor: Colors.black87,
                                  onDissmissCallback: (d) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const MyServices()));
                                  },
                                  btnCancelOnPress: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const MyServices()));
                                  },
                                ).show();
                              }
                            },
                          ).show();

                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Reschedule'),
                        onPressed: () => {
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
                            )
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
    // child: ListTile(
        //   leading: Padding(
        //     padding: const EdgeInsets.only(top: 10.0),
        //     child: Text("${user.Duration.substring(0, 2)} min"),
        //   ),
        //   title: Text(user.Service),
        //   subtitle: Text('days : ${user.days}\nOffice hour: ${user.Time}'),
        //   trailing: const Icon(Icons.arrow_forward_ios),
        //   contentPadding:
        //       const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        //   onTap: () {
        //     print(FirebaseFirestore.instance
        //         .collection('Service')
        //         .doc('user.uid')
        //         .get()
        //         .then((value) => print(value)));
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => DeleteSelectService(
        //           serviceName: user.Service,
        //           days: user.days,
        //           time: user.Time,
        //           duration: user.Duration,
        //           uid: user.id,
        //         ),
        //       ),
        //     );
        //   },
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        //   ),
        //   tileColor: Colors.grey.shade300,
        // ),
      );
}
