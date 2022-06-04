import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/user_class.dart';

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({Key? key}) : super(key: key);

  @override
  State<AdminFeedback> createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedbacks'),
        centerTitle: true,
        backgroundColor: Color(0xff205375),
      ),
      body: StreamBuilder<List<SendFeedback>>(
        stream: readReservation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(12.0),
              children: [...user.map(feedbackListTile).toList()],
            );
          } else {
            return Text("");
          }
        },
      ),
    );
  }

  Stream<List<SendFeedback>> readReservation() {
    var ref2 = FirebaseFirestore.instance
        .collection('feedback')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SendFeedback.fromJson(doc.data()))
            .toList());

    return ref2;
  }

  Widget feedbackListTile(SendFeedback user) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListTile(
        title: Text("${user.name} did ${user.title}"),
        subtitle: Text(user.message),
        trailing: const Icon(Icons.arrow_forward_ios),
        tileColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
