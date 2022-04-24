import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'make_reservations.dart';
import 'navigation_drawer.dart';

class CardsNumber extends ChangeNotifier{
  int numberOfCards;
  CardsNumber({this.numberOfCards = 0});
  void addCard(){
    numberOfCards++;
    notifyListeners();
}
}

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key, void function}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {

    int numberOfCards = Provider.of<CardsNumber>(context).numberOfCards;
    String selectedService = Provider.of<ReservationInfo>(context).selectedService;
    String name = selectedService;

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
      body: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: numberOfCards,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('3/16'),
                    ),
                    title: Text(name),
                    subtitle: const Text(
                        'People in front of you: 5 \nExpected time: 9:45'),
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
              },
            ),
    );
  }
}
/*

children: [
          ListTile(
            leading: const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text('3/16'),
            ),
            title: const Text('Appointment 1'),
            subtitle: const Text('People in front of you: 5 \nExpected time: 9:45'),
            trailing: const Icon(Icons.arrow_forward_ios),
            contentPadding: const EdgeInsets.symmetric(vertical: 15 ,horizontal: 15),
            onTap: () {

            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            tileColor: Colors.grey.shade300,
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text('3/17'),
            ),
            title: const Text('Appointment 2'),
            subtitle: const Text('People in front of you: 7 \nExpected time: 11:30'),
            trailing: const Icon(Icons.arrow_forward_ios),
            contentPadding: const EdgeInsets.symmetric(vertical: 15 ,horizontal: 15),
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            tileColor: Colors.grey.shade300,
          ),
        ],
 */