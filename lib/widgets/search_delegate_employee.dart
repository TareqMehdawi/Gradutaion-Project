import 'package:flutter/material.dart';
import 'package:graduation_project/pages/make_reservations.dart';

class EmployeeSearchDelegate extends SearchDelegate {

  List<String> registration = [
    'Tareq Mehdawi',
    'Mohammad Al-Masri',
    'Abdullah Wrikat',
    'Mohammad Ayasrah',
  ];

  List<String> doctors = [
    'Marwan Al-Taweel',
    'Reem al-Faiz',
    'Rola Al-Khalid',
    'Ansar Khori',
    'Bashar Shboul',
  ];
  List<String> allEmployees = [
    'Marwan Al-Taweel',
    'Reem al-Faiz',
    'Rola Al-Khalid',
    'Ansar Khori',
    'Bashar Shboul',
    'Tareq Mehdawi',
    'Mohammad Al-Masri',
    'Abdullah Wrikat',
    'Mohammad Ayasrah',
  ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          if(query.isNotEmpty) {
            close(context, query);
          } else{
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
              query ='Employee';
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
    if (whichEmployee == 1) {
      List<String> suggestions = doctors.where((searchResult) {
        final result = searchResult.toLowerCase();
        final input = query.toLowerCase();

        return result.contains(input);
      }).toList();

      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              close(context, query);
            },
          );
        },
      );
    }
    else if(whichEmployee == 2) {
      List<String> suggestions = registration.where((searchResult) {
        final result = searchResult.toLowerCase();
        final input = query.toLowerCase();

        return result.contains(input);
      }).toList();

      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              close(context, query);
            },
          );
        },
      );
    }
    else{
      List<String> suggestions = allEmployees.where((searchResult) {
        final result = searchResult.toLowerCase();
        final input = query.toLowerCase();

        return result.contains(input);
      }).toList();

      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              close(context, query);
            },
          );
        },
      );
    }
  }
}
