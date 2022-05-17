import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/make_reservations.dart';
import 'package:graduation_project/widgets/user_class.dart';
import 'package:provider/provider.dart';

class ServicesSearchDelegate extends SearchDelegate {
  // final CollectionReference _service =
  // FirebaseFirestore.instance.collection('Service');

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
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<setEmpService>>(
        stream: readServices(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(12.0),
              children: users.map(buildListTile).toList(),
            );
          } else if (snapshot.hasError) {
            return  Center(
              child: Text("${snapshot.error}"),
            );
          } else {
            return const Center(
              child: Text("Loading"),
            );
          }
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<setEmpService>>(
        stream: readServices(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(12.0),
              children: users.map(buildListTile).toList(),
            );
          } else if (snapshot.hasError) {
            return  Center(
              child: Text("${snapshot.error}"),
            );
          } else {
            return const Center(
              child: Text("Loading"),
            );
          }
        }
    );
  }
  Stream<List<setEmpService>> readServices(BuildContext context) {
    final id = Provider.of<ReservationInfo>(context).selectedEmployeeId ;
    return FirebaseFirestore.instance
        .collection('Service')
        .where("id", isEqualTo: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => setEmpService.fromJson(doc.data()))
        .toList());
  }
  Widget buildListTile(setEmpService service) => Builder(
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ListTile(
          leading:  const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          title: Text(service.Service),
          subtitle:  Text(
              'Service: ${service.Service} \nExpected time: ${service.Time}'),
          trailing: const Icon(Icons.arrow_forward_ios),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 15),
          onTap: () {
            Provider.of<ReservationInfo>(context,listen: false).selectedService = service.Service ;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                    const ReservationPage()));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          tileColor: Colors.grey.shade300,
        ),
      );
    }
  );
}
