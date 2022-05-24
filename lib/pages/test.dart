import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../styles/colors.dart';

String tareq = "tareq";

class Tareq extends StatefulWidget {
  const Tareq({Key? key}) : super(key: key);

  @override
  State<Tareq> createState() => _TareqState();
}

enum FilterStatus { Upcoming, Complete, Cancel }

List<Map> schedules = [
  {

    'img': 'assets/doctor01.jpeg',
    'doctorName': 'Dr. Anastasya Syahid',
    'doctorTitle': 'Dental Specialist',
    'reservedDate': 'Monday, Aug 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Upcoming
  }];





class _TareqState extends State<Tareq> {
  bool s = false;
  bool m = false;
  String hour =  TimeOfDay.now().hourOfPeriod.toString().padLeft(2,'0');
  String minutes = TimeOfDay.now().minute.toString().padLeft(2,'0');
  final user = FirebaseAuth.instance.currentUser!;
  FilterStatus status = FilterStatus.Upcoming;

  @override
  Widget build(BuildContext context) {
    List<Map> filteredSchedules = schedules.where((var schedule) {
      return schedule['status'] == status;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      primary: false,
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: SafeArea(
            child: Container(
              color: Theme.of(context).primaryColor,
              width: MediaQuery.of(context).size.width,
              // Set Appbar wave height
              child: Container(
                height: 80,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Container(
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        RotatedBox(
                            quarterTurns: 2,
                            child: WaveWidget(
                              config: CustomConfig(
                                colors: [Theme.of(context).primaryColor],
                                durations: [22000],
                                heightPercentages: [-0.1],
                              ),
                              size: Size(double.infinity, double.infinity),
                              waveAmplitude: 1,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Builder(
                              builder: (context) => IconButton(
                                onPressed: () {
                                  setState(() {
                                    //Provider.of<NavigationProvider>(context, listen: false)
                                        //.changeValue();
                                  });
                                },
                                icon: const Icon(Icons.menu),
                              )
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 50),
                                child: Text(
                                  "Employee page",
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                )),
                          ],
                        ),
                      ],
                    )),
              ),
            )),
      ),
      body: ListView(
        children:[
          Expanded(
            child:  Card(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/a.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "_schedule['doctorName']",
                                  style: TextStyle(
                                    color: Color(MyColors.header01),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "_schedule['doctorTitle']",
                                  style: TextStyle(
                                    color: Color(MyColors.grey02),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DateTimeCard(),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                child: Text('Cancel'),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: Text('Reschedule'),
                                onPressed: () => {},
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(MyColors.primary),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    //onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/doctor01.jpeg'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Dr.Muhammed Syahid',
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Dental Specialist',
                                    style: TextStyle(color: Color(MyColors.text01)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ScheduleCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(MyColors.bg02),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(MyColors.bg03),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
            ],
          )
        ]
      ),
    );
  }
  Widget listTile(){
    return ListTile(
      leading: const Icon(Icons.add) ,
      title: Text("$hour : $minutes"),
      onTap: (){
        setState(() {
        });
      },
    );
  }
  addTime({required String t}){
    String t = hour;
    switch(t){
      case '11:11':
    }
  }
}
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg01),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Mon, July 29',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              '11:00 ~ 12:10',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
class DateTimeCard extends StatelessWidget {
  const DateTimeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                color: Color(MyColors.primary),
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Mon, July 29',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.access_alarm,
                color: Color(MyColors.primary),
                size: 17,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '11:00 ~ 12:10',
                style: TextStyle(
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}