import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../widgets/user_class.dart';

class DeleteSelectService extends StatefulWidget {
  String time;
  String serviceName;
  String duration;
  List<dynamic> days;
  String uid;
  final currentUser = FirebaseAuth.instance.currentUser!;

  DeleteSelectService(
      {Key? key,
      required this.serviceName,
      required this.days,
      required this.time,
      required this.duration,
      required this.uid})
      : super(key: key);

  @override
  State<DeleteSelectService> createState() => _DeleteSelectService();
}

class _DeleteSelectService extends State<DeleteSelectService> {
  TextEditingController serviceController = TextEditingController();
  int currentStep = 0;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? duration;
  TimeOfDay time = TimeOfDay.now();

  //List<Message> messages = [];
  List<String> Newdays = [];
  final currentUser = FirebaseAuth.instance.currentUser!;

  String? selectedValue;
  List<String> items = [
    '5 minute',
    '10 minute',
    '15 minute',
    '20 minute',
    '25 minute',
    '30 minute',
  ];

  List<DayInWeek> daysSelected() {
    final List<DayInWeek> _days = [
      DayInWeek(
        "Sunday",
      ),
      DayInWeek(
        "Monday",
      ),
      DayInWeek(
        "Tuesday",
      ),
      DayInWeek(
        "Wednesday",
      ),
      DayInWeek(
        "Thursday",
      ),
      DayInWeek(
        "Friday",
      ),
      DayInWeek(
        "Saturday",
      ),
    ];
    for (int i = 0; i < _days.length; i++) {
      for (int j = 0; j < widget.days.length; j++) {
        if (_days[i].dayName == widget.days[j]) {
          _days[i].isSelected = true;
          break;
        }
      }
    }

    return _days;
  }

  String? time2;

  String? getTime() {
    if (startTime == null && endTime == null) {
      return widget.time;
    } else {
      time2 =
          "${startTime.toString().substring(10, 15)} - ${endTime.toString().substring(10, 15)}";
      return time2;
    }
  }

  @override
  Widget build(BuildContext context) {
    // String selectedService =
    //     Provider.of<ReservationInfo>(context).selectedService;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff141E27),
        title: Text(widget.serviceName),
        centerTitle: true,
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: serviceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Change service name',
                labelText: 'Service',
                suffixIcon: Icon(
                  Icons.design_services_rounded,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: SelectWeekDays(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              days: daysSelected(),
              border: false,
              boxDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [Color(0xFFE55CE4), Color(0xFFBB75FB)],
                  tileMode:
                      TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              onSelect: (values) {
                // <== Callback to handle the selected days
                Newdays = [];
                Newdays.addAll(values);
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 320,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          maximumSize: const Size.fromHeight(40),
                          primary: Colors.black),
                      child: FittedBox(
                        child: Text(
                          getTime()!,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        TimeRange result = await showTimeRangePicker(
                            context: context,
                            start: const TimeOfDay(hour: 9, minute: 0),
                            end: const TimeOfDay(hour: 12, minute: 0),
                            disabledTime: TimeRange(
                                startTime: const TimeOfDay(hour: 18, minute: 0),
                                endTime: const TimeOfDay(hour: 6, minute: 0)),
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
                          startTime = result.startTime;
                          endTime = result.endTime;
                        });
                      },
                    ),
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    children: [
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
                          widget.duration,
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
                      duration = value;
                      print(value);
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
          ),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 150, left: 50),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                             updateServiceName(servicename: serviceController.text);
                             updateTime(time: time2!);
                             updateDuration(durationn: duration!);
                            updateDays(day: Newdays);
                          },
                        ),
                      ))),
              SizedBox(
                width: 4,
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () async {
                            deleteService();
                          },
                        ),
                      )))
            ],
          )
        ],
      ),
    );
  }

  Future updateDays({required List<String> day}) async {


    final  docUser2 = await FirebaseFirestore
        .instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid).get();
        for(var doc in docUser2.docs) {
          await FirebaseFirestore.instance
              .collection('Service').doc(doc.id).update({'days':day});

        }
  }

  Future updateServiceName({required String servicename}) async {
    final  docUser2 = await FirebaseFirestore
        .instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid).get();
    for(var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service').doc(doc.id).update({'Service':servicename});

    }
  }

  Future updateTime({required String time}) async {
    final  docUser2 = await FirebaseFirestore
        .instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid).get();
    for(var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service').doc(doc.id).update({'Time':time});

    }
  }

  Future updateDuration({required String durationn}) async {
    final  docUser2 = await FirebaseFirestore
        .instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid).get();
    for(var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service').doc(doc.id).update({'Duration':durationn});

    }
  }
  Future deleteService() async {
    final  docUser2 = await FirebaseFirestore
        .instance
        .collection('Service')
        .where('Service', isEqualTo: widget.serviceName)
        .where('id', isEqualTo: widget.uid).get();
    for(var doc in docUser2.docs) {
      await FirebaseFirestore.instance
          .collection('Service').doc(doc.id).delete();

    }
  }

}
