import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/make_reservations.dart';
import 'package:graduation_project/pages/your_account2.dart';
import 'package:provider/provider.dart';

class EmployeeSearchDelegate extends SearchDelegate {
  String stdName;
  String stdImage;
  EmployeeSearchDelegate(
      {required this.type, required this.stdName, required this.stdImage});

  final String type;
  final CollectionReference _employees =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _employees.snapshots().asBroadcastStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            ///////////////////////////////////////////////////////////////////
            return const Center(
              child: Text('NO DATA!'),
            );
          } else {
            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element['name']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .isEmpty) {
              return const Center(
                child: Text('No results found!'),
              );
            } else {
              return ListView(
                children: [
                  ...snapshot.data!.docs
                      .where((QueryDocumentSnapshot<Object?> element) =>
                          element['name']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .map((QueryDocumentSnapshot<Object?> data) {
                    final String name = data.get('name');
                    final String id = data.get('id');
                    final String image = data.get('imageUrl');
                    final String email = data.get('email');
                    return ListTile(
                      onTap: () {
                        Provider.of<ReservationInfo>(context, listen: false)
                            .selectedEmployee = data.get('name');
                        close(context, null);
                        Provider.of<ReservationInfo>(context, listen: false)
                            .selectedEmployeeId = id;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const ReservationPage()));
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(image),
                      ),
                      title: Text(name),
                      subtitle: Text(email),
                    );
                  })
                ],
              );
            }
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _employees.where("type", isEqualTo: type).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            ///////////////////////////////////////////////////////////////////
            return Center(
              child: Text(type),
            );
          } else {
            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element['name']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .isEmpty) {
              return const Center(
                child: Text('No results found!'),
              );
            } else {
              return ListView(
                children: [
                  // ... operator so u can add widgets before it
                  ...snapshot.data!.docs
                      .map((QueryDocumentSnapshot<Object?> data) {
                    final String name = data.get('name');
                    final String id = data.get('id');
                    final String image = data.get('imageUrl');
                    final String email = data.get('email');
                    return ListTile(
                      onTap: () {
                        // Provider.of<ReservationInfo>(context, listen: false)
                        //     .selectedEmployee = data.get('name');
                        // Provider.of<ReservationInfo>(context,listen: false).selectedEmployeeId = id ;
                        close(context, null);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => YourAccount2(
                              uid: id,
                              stdName: stdName,
                              stdImage: stdImage,
                            ),
                          ),
                        );
                        // Provider.of<ReservationInfo>(context,listen: false).selectedEmployeeId = id ;
                        // query = name;
                        // close(context, query);
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(image),
                      ),
                      title: Text(name),
                      subtitle: Text(email),
                    );
                  })
                ],
              );
            }
          }
        });
  }
}
