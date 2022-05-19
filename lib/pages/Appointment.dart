import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingScreen extends StatefulWidget {
  final String uid;

  const BookingScreen({Key ?key, required this.uid}) : super(key: key);
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

  List sendItem(List items2){
    List items =[];
    for(var i=0;i<items2.length;i++){
      String a= items2[i]["Service"];
      items.add(a);
    }
    return items;
  }
  List sendItem2(List items2){
    List items =[];
    for(var i=0;i<items2.length;i++){
      if(items2[i]["Service"]== serviceSelect) {
        for(var j=0;j<items2[i]["days"].length;j++) {
          items.add(items2[i]["days"][j]);
        }
      }
    }
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
              }else if (snapshot.hasData) {
                final List user = snapshot.data as List ;
                return ListView(
                  shrinkWrap: true,
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
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.only(top: 0),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 16),
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
                                items: sendItem(user)
                                    .map((item) =>
                                    DropdownMenuItem(
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
                                    serviceSelect =value;
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
                            const SizedBox(
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
                                items: sendItem2(user)
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
                                value: selectedValue2,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue2 = value as String;
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
                            const SizedBox(
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
                                      contentPadding: const EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      border: const OutlineInputBorder(
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
                                      if (value!.isEmpty) {
                                        return 'Please Enter the Time';
                                      }
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
                                          child: const SizedBox(
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
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
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
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }else {
                //print(snapshot.error);
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

}