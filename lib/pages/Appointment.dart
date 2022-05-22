import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingScreen extends StatefulWidget {
  final String uid;

  const BookingScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select Time';
  String? dateTime;
  bool isLoading = false;
  String? selectedValue;
  String? selectedValue2;
  String? serviceSelect;
  String? daySelect;
  int? serviceIndex;
  bool isSelected = false;
  int? onTimeSelect;

  // static const orange = Color(0xFFFE9A75);
  // static const dark = Color(0xFF333A47);
  // static const double leftPadding = 0;

  List sendItem(List items2) {
    List items = [];
    for (var i = 0; i < items2.length; i++) {
      String a = items2[i]["Service"];
      items.add(a);
    }
    return items;
  }

  List sendItem2(List items2) {
    List items = [];
    for (var i = 0; i < items2.length; i++) {
      if (items2[i]["Service"] == serviceSelect) {
        serviceIndex = i;
        for (var j = 0; j < items2[i]["days"].length; j++) {
          items.add(items2[i]["days"][j]);
        }
      }
    }
    return items;
  }

  //09:00 - 10:00
  //30
  List sendItem3(List items2) {
    List items = [];
    int duration =
        int.parse(items2[serviceIndex!]["Duration"].toString().substring(0, 2));
    int endMin =
        int.parse(items2[serviceIndex!]["Time"].toString().substring(11, 13));
    int endHour =
        int.parse(items2[serviceIndex!]["Time"].toString().substring(8, 10));
    // print(duration);
    // print(endMin);
    // print(items2[serviceIndex!]["days"][0]);
    //
    // print(endHour);
    int min =
        int.parse(items2[serviceIndex!]["Time"].toString().substring(3, 5));
    int hour =
        int.parse(items2[serviceIndex!]["Time"].toString().substring(0, 2));
    int min2;
    while (hour <= endHour) {
      int minute = min;
      int ho = hour;
      min = min + duration;
      if (min < 60) {
        if (!(min > endMin && hour == endHour)) {
          if (hour <= endHour) {
            items.add(
                '${ho.toString().padLeft(2, "0")} : ${minute.toString().padLeft(2, "0")} - ${hour.toString().padLeft(2, "0")} : ${min.toString().padLeft(2, "0")} ');
          }
        }
      } else if (min >= 60) {
        min2 = min - 60;
        hour++;
        if (!(min2 > endMin && hour == endHour)) {
          if (hour <= endHour) {
            items.add(
                '${ho.toString().padLeft(2, "0")} : ${minute.toString().padLeft(2, "0")} - ${hour.toString().padLeft(2, "0")} : ${min2.toString().padLeft(2, "0")} ');
          }
          min = min2;
        }
      }
    }
    // print(items);

    return items;
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime!,
        alwaysUse24HourFormat: false);

    setState(() {
      timeText = formattedTime;
      _timeController.text = timeText;
    });
    dateTime = selectedTime.toString().substring(10, 15);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _timeRange = _defaultTimeRange;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Appointment booking',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else if (snapshot.hasData) {
                final List user = snapshot.data as List;
                // int startHour =
                // int.parse(user[5]['Time'].toString().substring(0, 2));
                // int startMinute =
                // int.parse(user[5]['Time'].toString().substring(3, 5));
                // int finishHour =
                // int.parse(user[5]['Time'].toString().substring(8, 10));
                // int finishMinute =
                // int.parse(user[5]['Time'].toString().substring(11, 13));
                // final defaultTimeRange = TimeRangeResult(
                //   TimeOfDay(
                //       hour:
                //           startHour,
                //       minute: startMinute),
                //   TimeOfDay(
                //       hour: startHour,
                //       minute: finishMinute = 10),
                // );
                // TimeRangeResult? timeRange;
                //
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/a.png'),
                      height: 250,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Expanded(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 18),
                              child: Text(
                                'Enter Appointment information',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: DropdownButtonHideUnderline(
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
                                          'Select Service',
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
                                  items: sendItem(user)
                                      .map(
                                        (item) => DropdownMenuItem(
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
                                        ),
                                      )
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue2 = null;
                                      selectedValue = value as String;
                                      serviceSelect = value;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.yellow,
                                  iconDisabledColor: Colors.grey,
                                  buttonHeight: 50,
                                  buttonWidth: 500,
                                  buttonPadding:
                                      const EdgeInsets.only(left: 14, right: 14),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.redAccent,
                                  ),
                                  buttonElevation: 2,
                                  itemHeight: 40,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 14),
                                  dropdownMaxHeight: 200,
                                  dropdownPadding: null,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.redAccent,
                                  ),
                                  dropdownElevation: 8,
                                  scrollbarRadius: const Radius.circular(40),
                                  scrollbarThickness: 6,
                                  scrollbarAlwaysShow: true,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: DropdownButtonHideUnderline(
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
                                          'Select Day',
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
                                  items: sendItem2(user)
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
                                  value: selectedValue2,
                                  onChanged: (value) {
                                    setState(() {
                                      isSelected = true;
                                      selectedValue2 = value as String;
                                      daySelect = value;
                                      //print(value);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.yellow,
                                  iconDisabledColor: Colors.grey,
                                  buttonHeight: 50,
                                  buttonWidth: 500,
                                  buttonPadding:
                                      const EdgeInsets.only(left: 14, right: 14),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.redAccent,
                                  ),
                                  buttonElevation: 2,
                                  itemHeight: 40,
                                  itemPadding:
                                      const EdgeInsets.only(left: 14, right: 14),
                                  dropdownMaxHeight: 200,
                                  dropdownPadding: null,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.redAccent,
                                  ),
                                  dropdownElevation: 8,
                                  scrollbarRadius: const Radius.circular(40),
                                  scrollbarThickness: 6,
                                  scrollbarAlwaysShow: true,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if(isSelected == true)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 30),
                                child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: sendItem3(user).length,
                                  itemBuilder:  (BuildContext context, int index) =>
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              onTimeSelect = index;
                                              //onTimeSelect = !onTimeSelect;
                                            });
                                          },
                                          borderRadius: BorderRadius.circular(32.0),
                                          splashColor: Colors.indigo,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius: BorderRadius.circular(32.0),
                                              color: onTimeSelect == index ? Colors.indigo : Colors.white12,
                                            ),
                                            height: 30,
                                            child: Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(sendItem3(user)[index] ,style: const TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                                            )),
                                          ),
                                        ),
                                      ),
                            ),
                              ),
                            ),
                            // TimeRange(
                            //   fromTitle: const Text(
                            //     'FROM',
                            //     style: TextStyle(
                            //       fontSize: 14,
                            //       color: dark,
                            //       fontWeight: FontWeight.w600,
                            //     ),
                            //   ),
                            //   toTitle: const Text(
                            //     'TO',
                            //     style: TextStyle(
                            //       fontSize: 14,
                            //       color: dark,
                            //       fontWeight: FontWeight.w600,
                            //     ),
                            //   ),
                            //   titlePadding: leftPadding,
                            //   textStyle: const TextStyle(
                            //     fontWeight: FontWeight.normal,
                            //     color: dark,
                            //   ),
                            //   activeTextStyle: const TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     color: orange,
                            //   ),
                            //   borderColor: dark,
                            //   activeBorderColor: dark,
                            //   backgroundColor: Colors.transparent,
                            //   activeBackgroundColor: dark,
                            //   firstTime: TimeOfDay(
                            //       hour: startHour,
                            //       minute: startMinute),
                            //   lastTime: TimeOfDay(
                            //       hour: finishHour,
                            //       minute: finishMinute),
                            //   initialRange: defaultTimeRange,
                            //   timeStep: 10,
                            //   timeBlock: 10,
                            //   onRangeCompleted: (range) => setState(() {
                            //     timeRange = range;
                            //     print(timeRange!.start);
                            //   }),
                            // ),
                            // SizedBox(height: 30),
                            // if (timeRange != null)
                            //   Padding(
                            //     padding: const EdgeInsets.only(
                            //         top: 8.0, left: leftPadding),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: <Widget>[
                            //         Text(
                            //           'Selected Range: ${timeRange!.start.format(context)} - ${timeRange!.end.format(context)}',
                            //           style:
                            //               TextStyle(fontSize: 20, color: dark),
                            //         ),
                            //         SizedBox(height: 20),
                            //         MaterialButton(
                            //           child: Text('Default'),
                            //           onPressed: () => setState(
                            //               () => timeRange = defaultTimeRange),
                            //           color: orange,
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // Container(
                            //   alignment: Alignment.center,
                            //   height: 60,
                            //   width: MediaQuery.of(context).size.width,
                            //   child: Stack(
                            //     alignment: Alignment.centerRight,
                            //     children: [
                            //       TextFormField(
                            //         focusNode: f5,
                            //         decoration: InputDecoration(
                            //           contentPadding: const EdgeInsets.only(
                            //             left: 20,
                            //             top: 10,
                            //             bottom: 10,
                            //           ),
                            //           border: const OutlineInputBorder(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(90.0)),
                            //             borderSide: BorderSide.none,
                            //           ),
                            //           filled: true,
                            //           fillColor: Colors.grey[350],
                            //           hintText: 'Select Time*',
                            //           hintStyle: GoogleFonts.lato(
                            //             color: Colors.black26,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.w800,
                            //           ),
                            //         ),
                            //         controller: _timeController,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return 'Please Enter the Time';
                            //           }
                            //           return null;
                            //         },
                            //         onFieldSubmitted: (String value) {
                            //           f5.unfocus();
                            //         },
                            //         textInputAction: TextInputAction.next,
                            //         style: GoogleFonts.lato(
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(right: 5.0),
                            //         child: ClipOval(
                            //           child: Material(
                            //             color: Colors.indigo, // button color
                            //             child: InkWell(
                            //               // inkwell color
                            //               child: const SizedBox(
                            //                 width: 40,
                            //                 height: 40,
                            //                 child: Icon(
                            //                   Icons.timer_outlined,
                            //                   color: Colors.white,
                            //                 ),
                            //               ),
                            //               onTap: () {
                            //                 selectTime(context);
                            //               },
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    primary: Colors.indigo,
                                    onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    sendItem3(user);
                                  },
                                  child: Text(
                                    "Book Appointment",
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                //print(snapshot.error);
                /////////////////////////////
                return const Center(
                  child: Text('Loading...'),
                );
              }
            }),
      ),
    );
  }

  Future readUser() async {
    List data = [];
    setState(() {
      isLoading = true;
    });
    final getUser = FirebaseFirestore.instance
        .collection('Service')
        .where('id', isEqualTo: widget.uid);
    final snapshot = await getUser.get();
    for (var ele in snapshot.docs) {
      data.add(ele.data());
    }
    if (data.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      return data;
    }
  }
}

// Widget dropDownButton({required List user,required String title, required String? selectedValue10,required List Function(List) sendItem}){
//   return DropdownButtonHideUnderline(
//     child: DropdownButton2(
//       isExpanded: true,
//       hint: Row(
//         children: [
//           const Icon(
//             Icons.list,
//             size: 16,
//             color: Colors.yellow,
//           ),
//           const SizedBox(
//             width: 4,
//           ),
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.yellow,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//       items: sendItem(user)
//           .map(
//             (item) => DropdownMenuItem(
//           value: item,
//           child: Text(
//             item,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ).toList(),
//       value: selectedValue10,
//       onChanged: (value) {
//         setState(() {
//           selectedValue10 = value as String;
//           print(selectedValue10);
//           serviceSelect = value;
//         });
//       },
//       icon: const Icon(
//         Icons.arrow_forward_ios_outlined,
//       ),
//       iconSize: 14,
//       iconEnabledColor: Colors.yellow,
//       iconDisabledColor: Colors.grey,
//       buttonHeight: 50,
//       buttonWidth: 500,
//       buttonPadding:
//       const EdgeInsets.only(left: 14, right: 14),
//       buttonDecoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: Colors.black26,
//         ),
//         color: Colors.redAccent,
//       ),
//       buttonElevation: 2,
//       itemHeight: 40,
//       itemPadding:
//       const EdgeInsets.symmetric(horizontal: 14),
//       dropdownMaxHeight: 200,
//       dropdownPadding: null,
//       dropdownDecoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         color: Colors.redAccent,
//       ),
//       dropdownElevation: 8,
//       scrollbarRadius: const Radius.circular(40),
//       scrollbarThickness: 6,
//       scrollbarAlwaysShow: true,
//     ),
//   );
// }
