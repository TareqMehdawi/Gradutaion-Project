import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/class.dart';
import 'package:graduation_project/widgets/search_delegate_services.dart';
import 'package:graduation_project/widgets/user_class.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../widgets/search_delegate_employee.dart';
import 'package:provider/provider.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);





  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  int currentStep = 0;
  DateTime ?date;
  TimeOfDay time = TimeOfDay.now();
  List<Message> messages = [];
  List<String> days = [];
  final currentUser = FirebaseAuth.instance.currentUser!;
  TimeOfDay ?starttime;
  TimeOfDay ?endtime;
  String dropdownvalue = 'Item 1';

  String getTime(){
   if(starttime ==null && endtime ==null)
     return "Select Time";
   else
     return "${starttime.toString().substring(10,15)} - ${endtime.toString().substring(10,15)}";



  }

  String? selectedValue;
  List<String> items = [
    '5 minute',
    '10 minute',
    '15 minute',
    '20 minute',
    '25 minute',
    '30 minute',
  ];

  List<DayInWeek> _days = [
    DayInWeek(
      "Sun",
    ),
    DayInWeek(
      "Mon",
    ),
    DayInWeek(
        "Tue",
        isSelected: true
    ),
    DayInWeek(
      "Wed",
    ),
    DayInWeek(
      "Thu",
    ),
    DayInWeek(
      "Fri",
    ),
    DayInWeek(
      "Sat",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff141E27),
          title: const Text('Add Service'),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your new service',
                  labelText: 'Service',
                  suffixIcon: Icon(
                    Icons.design_services_rounded,
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: SelectWeekDays(
                  fontSize:14,
                  fontWeight: FontWeight.w500,
                  days: _days,
                  border: false,
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [const Color(0xFFE55CE4), const Color(0xFFBB75FB)],
                      tileMode:
                      TileMode.repeated, // repeats the gradient over the canvas
                    ),
                  ),
                  onSelect: (values) {// <== Callback to handle the selected days
                    days=[];
                    days.addAll(values);
                  },
                ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 320,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            maximumSize: Size.fromHeight(40),
                            primary: Colors.black),
                        child: FittedBox(
                          child:  Text(
                            getTime(),
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          TimeRange result = await showTimeRangePicker(
                              context: context,
                              start: TimeOfDay(hour: 9, minute: 0),
                              end: TimeOfDay(hour: 12, minute: 0),
                              disabledTime: TimeRange(
                                  startTime: TimeOfDay(hour: 18, minute: 0),
                                  endTime: TimeOfDay(hour: 6, minute: 0)),
                              disabledColor: Colors.red.withOpacity(0.5),
                              strokeWidth: 4,
                              ticks: 24,
                              ticksOffset: -7,
                              ticksLength: 15,
                              ticksColor: Colors.grey,
                              labels: [
                                "12 am",
                                "3 am",
                                "6 am",
                                "9 am",
                                "12 pm",
                                "3 pm",
                                "6 pm",
                                "9 pm"
                              ].asMap().entries.map((e) {
                                return ClockLabel.fromIndex(
                                    idx: e.key, length: 8, text: e.value);
                              }).toList(),
                              labelOffset: 35,
                              rotateLabels: false,
                              padding: 60);
                         setState(() {
                           starttime= result.startTime;
                           endtime=result.endTime;
                         });
                        },
                      ),
                    ))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child:  DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    children: const [
                      Icon(
                        Icons.list,
                        size: 16,
                        color: Colors.yellow,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'Select Time',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as String;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.yellow,
                  iconDisabledColor: Colors.grey,
                  buttonHeight: 50,
                  buttonWidth: 160,
                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.redAccent,
                  ),
                  buttonElevation: 2,
                  itemHeight: 40,
                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                  dropdownMaxHeight: 200,
                  dropdownWidth: 200,
                  dropdownPadding: null,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.redAccent,
                  ),
                  dropdownElevation: 8,
                  scrollbarRadius: const Radius.circular(40),
                  scrollbarThickness: 6,
                  scrollbarAlwaysShow: true,
                  offset: const Offset(-20, 0),
                ),
              ),
            ),

            Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 320,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Add',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )))
          ],
        ));
  }

  Future setReservation({
    required String doctor,
    required String service,
    required int people,
    required String currentTime,
    required String currentDate,
  }) async {
    final docUser = FirebaseFirestore.instance.collection('student').doc();
    final user = StudentsReservation(
      id: currentUser.uid,
      doctor: doctor,
      service: service,
      people: people,
      time: currentTime,
      date: currentDate,
    );
    final json = user.toJson();
    await docUser.set(json);
  }
}
