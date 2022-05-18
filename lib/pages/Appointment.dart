import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widgets/user_class.dart';

class BookingScreen extends StatefulWidget {
  final String uid;

   BookingScreen({Key ?key, required this.uid}) : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String abc="";
  String timeText = 'Select Time';
  String ?dateUTC;
  String ?date_Time;
  bool isLoading = false;
  String? selectedValue;
  //List item2=["dd","asdasd"];
  List<String> items = [
    '5 minute',
    '10 minute',
    '15 minute',
    '20 minute',
    '25 minute',
    '30 minute',
  ];

  // List item(String ar , List items2){
  //   List day=[];
  //   print(ar);
  //   for(var i=0;i<items2.length;i++){
  //
  //     if(items2[i]["Service"]== ar){
  //       day.add(items2[i]["days"]);
  //       print(day[0]);
  //       abc="";
  //       return day[0];
  //     }
  //
  //
  //
  //   }
  //   day.add("Select service");
  //   return day;
  // }

  // FirebaseAuth _auth = FirebaseAuth.instance;
  // User ?user;
  //
  // Future<void> _getUser() async {
  //   user = _auth.currentUser;
  // }

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then(
          (date) {
        setState(
              () {
            selectedDate = date!;
            String formattedDate =
            DateFormat('dd-MM-yyyy').format(selectedDate);
            _dateController.text = formattedDate;
            dateUTC = DateFormat('yyyy-MM-dd').format(selectedDate);
          },
        );
      },
    );
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime!,
        alwaysUse24HourFormat: false);

    if (formattedTime != null) {
      setState(() {
        timeText = formattedTime;
        _timeController.text = timeText;
      });
    }
    date_Time = selectedTime.toString().substring(10, 15);
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MyAppointments(),
        //   ),
        // );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Done!",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Appointment is registered.",
        style: GoogleFonts.lato(),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  // void initState() {
  //   super.initState();
  //   _getUser();
  //   selectTime(context);
  //   _doctorController.text = widget.doctor;
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
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        // child: NotificationListener<OverscrollIndicatorNotification>(
        //   onNotification: (OverscrollIndicatorNotification overscroll) {
        //     overscroll.disallowGlow();
        //     return;
        //   },
          child: FutureBuilder(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
             return const Text('Something went wrong');
                 }else if (snapshot.hasData) {
                final List user = snapshot.data as List ;
                List<String> itemm =[];
                for(var i=0;i<user.length;i++){
                  String a= user[i]["Service"];
                  itemm.add(a);
                }
                //print(itemm);
                // for(var i=0;i<user.length;i++){
                //   String a= user[i]["days"];
                //   itemm.add(a);
                // }
              return ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    child: Image(
                      image: AssetImage('assets/images/a.png'),
                      height: 250,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.only(top: 0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Enter Appointment information',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          DropdownButtonHideUnderline(
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
                              items: items
                                  .map((item) =>
                                  DropdownMenuItem<String>(
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
                              onChanged: ( value) {
                                setState(() {
                                  selectedValue = value as String;
                                  // abc =value;
                                  // items.clear();
                                  // for(var i=0;i<user.length;i++){
                                  //   if(user[i]["Service"]== abc) {
                                  //     for(var j=0;j<user[i]["days"].length;j++) {
                                  //       items.add(user[i]["days"][j]);
                                  //     }
                                  //     print(items);
                                  //     break;
                                  //   }
                                  //
                                  // }
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
                              dropdownWidth: 400,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.redAccent,
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                              offset: const Offset(-15, 0),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DropdownButtonHideUnderline(
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
                              items: items
                                  .map((item) =>
                                  DropdownMenuItem<String>(
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
                              dropdownWidth: 400,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.redAccent,
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                              offset: const Offset(-15, 0),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextFormField(
                                  focusNode: f4,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      left: 20,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(90.0)),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[350],
                                    hintText: 'Select Date*',
                                    hintStyle: GoogleFonts.lato(
                                      color: Colors.black26,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  controller: _dateController,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'Please Enter the Date';
                                    return null;
                                  },
                                  onFieldSubmitted: (String value) {
                                    f4.unfocus();
                                    FocusScope.of(context).requestFocus(f5);
                                  },
                                  textInputAction: TextInputAction.next,
                                  style: GoogleFonts.lato(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.indigo, // button color
                                      child: InkWell(
                                        // inkwell color
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            Icons.date_range_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          selectDate(context);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextFormField(
                                  focusNode: f5,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      left: 20,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(90.0)),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[350],
                                    hintText: 'Select Time*',
                                    hintStyle: GoogleFonts.lato(
                                      color: Colors.black26,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  controller: _timeController,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'Please Enter the Time';
                                    return null;
                                  },
                                  onFieldSubmitted: (String value) {
                                    f5.unfocus();
                                  },
                                  textInputAction: TextInputAction.next,
                                  style: GoogleFonts.lato(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.indigo, // button color
                                      child: InkWell(
                                        // inkwell color
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            Icons.timer_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          selectTime(context);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
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
                                // if (_formKey.currentState.validate()) {
                                //   print(_nameController.text);
                                //   print(_dateController.text);
                                //   print(widget.doctor);
                                //   showAlertDialog(context);
                                //   _createAppointment();
                                // }
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
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }else {
                print(snapshot.error);
                /////////////////////////////
                return const Center(
                  child: Text('Loading...'),
                );
              }
            }
          ),
      ),
    );
  }
  Future readUser() async {
    List data=[];
    setState(() {
      isLoading = true;
    });
    final getUser =
    FirebaseFirestore.instance.collection('Service').where('id' ,isEqualTo: widget.uid);
    final snapshot = await getUser.get();
    for(var ele in snapshot.docs){
      data.add(ele.data());
    }
    if (data.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      return data;
    }

  }





//   Future<void> _createAppointment() async {
//     print(dateUTC + ' ' + date_Time + ':00');
//     FirebaseFirestore.instance
//         .collection('appointments')
//         .doc(user.email)
//         .collection('pending')
//         .doc()
//         .set({
//       'name': _nameController.text,
//       'phone': _phoneController.text,
//       'description': _descriptionController.text,
//       'doctor': _doctorController.text,
//       'date': DateTime.parse(dateUTC + ' ' + date_Time + ':00'),
//     }, SetOptions(merge: true));
//
//     FirebaseFirestore.instance
//         .collection('appointments')
//         .doc(user.email)
//         .collection('all')
//         .doc()
//         .set({
//       'name': _nameController.text,
//       'phone': _phoneController.text,
//       'description': _descriptionController.text,
//       'doctor': _doctorController.text,
//       'date': DateTime.parse(dateUTC + ' ' + date_Time + ':00'),
//     }, SetOptions(merge: true));
//   }
 }
