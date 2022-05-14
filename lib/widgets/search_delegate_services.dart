import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/make_reservations.dart';
import 'package:provider/provider.dart';

class ServicesSearchDelegate extends SearchDelegate {
  final CollectionReference _service =
  FirebaseFirestore.instance.collection('Service');
  String ?id;


  List<String> registrationServices = [
    'Student Proof',
    'Issuance of score sheet',
    'Open filled classes',
    'Check alternative materials',
    'Payments',
  ];

  List<String> doctorServices = [
    'ask about graduation project',
    'check midterm ',
    ' final marks',
    'Ask about field training',
    'Inquire about something'
  ];

  List<String> allServices = [
    'ask about graduation project',
    'check midterm ',
    ' final marks',
    'Ask about field training',
    'Inquire about something',
    'Student Proof',
    'Issuance of score sheet',
    'Open filled classes',
    'Check alternative materials',
    'Payments',
  ];

  ServicesSearchDelegate(String selectedEmpID){
    id= selectedEmpID;

  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          if (query.isNotEmpty) {
            close(context, query);
          } else {
            query = 'Service';
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
              query = 'Service';
              close(context, query);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildResults(BuildContext context) => const Text('');

  @override
  Widget buildSuggestions(BuildContext context) {
    // if (whichEmployee == 1) {
    //   List<String> suggestions = doctorServices.where((searchResult) {
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
    // } else if (whichEmployee == 2) {
    //   List<String> suggestions = registrationServices.where((searchResult) {
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
    // } else {
    //   List<String> suggestions = allServices.where((searchResult) {
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

    return StreamBuilder<QuerySnapshot>(
        stream: _service.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            ///////////////////////////////////////////////////////////////////
            return const Center(
              child: Text('yes'),
            );
          }else {
            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                element['id']
                    .toString()
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
                    final String name = data.get('Service');
                    print(name);
                    //final String id = data.get('id');
                    return ListTile(
                      onTap: () {
                        print(id);
                         Provider.of<ReservationInfo>(context, listen: false)
                             .selectedService = data.get('Service');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                const ReservationPage()));
                      },
                      leading: Text(name),
                      //trailing: Text(id),
                    );
                  })
                ],
              );
            }


          }
        }
    );
  }
}
