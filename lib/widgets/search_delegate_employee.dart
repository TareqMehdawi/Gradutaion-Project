import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/make_reservations.dart';

class EmployeeSearchDelegate extends SearchDelegate {
  final CollectionReference _doctors =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _employees =
      FirebaseFirestore.instance.collection('registration');



  //
  // List<String> registration = [
  //   'Tareq Mehdawi',
  //   'Mohammad Al-Masri',
  //   'Abdullah Wrikat',
  //   'Mohammad Ayasrah',
  // ];
  //
  // List<String> doctors = [
  //   'Marwan Al-Taweel',
  //   'Reem al-Faiz',
  //   'Rola Al-Khalid',
  //   'Ansar Khori',
  //   'Bashar Shboul',
  // ];
  // List<String> allEmployees = [
  //   'Marwan Al-Taweel',
  //   'Reem al-Faiz',
  //   'Rola Al-Khalid',
  //   'Ansar Khori',
  //   'Bashar Shboul',
  //   'Tareq Mehdawi',
  //   'Mohammad Al-Masri',
  //   'Abdullah Wrikat',
  //   'Mohammad Ayasrah',
  // ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          if (query.isNotEmpty) {
            close(context, query);
          } else {
            query = 'Employee';
            close(context, query);
          }
        },
        icon: const Icon(Icons.arrow_back),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              query = 'Employee';
              close(context, query);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  // @override
  // Widget buildResults(BuildContext context) => const Text('');

  @override
  Widget buildResults(BuildContext context) {
    switch(whichEmployee){
      case 1 : return StreamBuilder<QuerySnapshot>(
          stream: _doctors.snapshots().asBroadcastStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              ///////////////////////////////////////////////////////////////////
              return const Center(
                child: Text('yes'),
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
                      return ListTile(
                        leading: Text(name),
                      );
                    })
                  ],
                );
              }
            }
          });
      case 2 :  return StreamBuilder<QuerySnapshot>(
          stream: _employees.snapshots().asBroadcastStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              ///////////////////////////////////////////////////////////////////
              return const Center(
                child: Text('yes'),
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
                      return ListTile(
                        leading: Text(name),
                      );
                    })
                  ],
                );
              }
            }
          });
      default: return const Center(child: Text("HIIIIIIIIIIIIIIII"));
    }
    // if (whichEmployee == 1) {
    //
    // }else if (whichEmployee == 2) {
    //
    // }
    // else{
    //   return StreamBuilder<QuerySnapshot>(
    //       stream: _employees.snapshots().asBroadcastStream(),
    //       builder: (context, snapshot) {
    //         if (!snapshot.hasData) {
    //           ///////////////////////////////////////////////////////////////////
    //           return const Center(
    //             child: Text('yes'),
    //           );
    //         } else {
    //           if (snapshot.data!.docs
    //               .where((QueryDocumentSnapshot<Object?> element) =>
    //               element['name']
    //                   .toString()
    //                   .toLowerCase()
    //                   .contains(query.toLowerCase()))
    //               .isEmpty) {
    //             return const Center(
    //               child: Text('No results found!'),
    //             );
    //           } else {
    //             return ListView(
    //               children: [
    //                 ...snapshot.data!.docs
    //                     .where((QueryDocumentSnapshot<Object?> element) =>
    //                     element['name']
    //                         .toString()
    //                         .toLowerCase()
    //                         .contains(query.toLowerCase()))
    //                     .map((QueryDocumentSnapshot<Object?> data) {
    //                   final String name = data.get('name');
    //                   return ListTile(
    //                     leading: Text(name),
    //                   );
    //                 })
    //               ],
    //             );
    //           }
    //         }
    //       });
    // }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _doctors.snapshots().asBroadcastStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            ///////////////////////////////////////////////////////////////////
            return const Center(
              child: Text('yes'),
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
                    return ListTile(
                      leading: Text(name),
                    );
                  })
                ],
              );
            }
          }
        });
    // if (whichEmployee == 1) {
    //   List<String> suggestions = doctors.where((searchResult) {
    //     final result = searchResult.toLowerCase();
    //     final input = query.toLowerCase();
    //
    //     return result.contains(input);
    //   }).toList();
    //
    //   return ListView.builder(
    //     itemCount: suggestions.length,
    //     itemBuilder: (context, index) {
    //       final suggestion = suggestions[index];
    //
    //       return ListTile(
    //         title: Text(suggestion),
    //         onTap: () {
    //           query = suggestion;
    //           close(context, query);
    //         },
    //       );
    //     },
    //   );
    // }
    // else if (whichEmployee == 2) {
    //   List<String> suggestions = registration.where((searchResult) {
    //     final result = searchResult.toLowerCase();
    //     final input = query.toLowerCase();
    //
    //     return result.contains(input);
    //   }).toList();
    //
    //   return ListView.builder(
    //     itemCount: suggestions.length,
    //     itemBuilder: (context, index) {
    //       final suggestion = suggestions[index];
    //
    //       return ListTile(
    //         title: Text(suggestion),
    //         onTap: () {
    //           query = suggestion;
    //           close(context, query);
    //         },
    //       );
    //     },
    //   );
    // }
    // else {
    //   List<String> suggestions = allEmployees.where((searchResult) {
    //     final result = searchResult.toLowerCase();
    //     final input = query.toLowerCase();
    //
    //     return result.contains(input);
    //   }).toList();
    //
    //   return ListView.builder(
    //     itemCount: suggestions.length,
    //     itemBuilder: (context, index) {
    //       final suggestion = suggestions[index];
    //
    //       return ListTile(
    //         title: Text(suggestion),
    //         onTap: () {
    //           query = suggestion;
    //           close(context, query);
    //         },
    //       );
    //     },
    //   );
    // }
  }
}
