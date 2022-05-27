import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';

import '../widgets/user_class.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  TextEditingController serviceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int currentStep = 0;
  DateTime? date;
  String? startTime;
  String? endTime;
  String? duration;
  TimeOfDay time = TimeOfDay.now();

  //List<Message> messages = [];
  Map days = {};
  final currentUser = FirebaseAuth.instance.currentUser!;

  //String dropdownvalue = 'Item 1';
  String? time2;

  // String? getStartTime() {
  //   if (startTime == null) {
  //     return "Select Time";
  //   } else {
  //     return startTime.toString().substring(10, 15);
  //   }
  // }

  String? selectedValue;
  List<String> items = [
    '5 minute',
    '10 minute',
    '15 minute',
    '20 minute',
    '25 minute',
    '30 minute',
  ];
  List<DayInWeek> officeHoursDays( UserAccount? user){
    final List<DayInWeek> days=[];
    List day=[];
    day.addAll(user!.officeHours.keys);
    for(int i=0; i<day.length;i++) {
     days.add(DayInWeek(day[i].toString()));
    }

      return days;
  }
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

  @override
  void dispose() {
    serviceController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   readUser();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff205375),
        title: const Text('Add Service'),
        leading: const BackButton(),
        centerTitle: true,
      ),
      body: FutureBuilder<UserAccount?>(
          future: readUser(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
            final user = snapshot.data!;
            return Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        "assets/images/bottom_left.png",
                        width: MediaQuery.of(context).size.width * .3,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Image(
                        image: AssetImage('assets/images/addservice.gif'),
                        height: 250,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: formKey,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, top: 0, bottom: 0, right: 20),
                            child: TextFormField(
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: serviceController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[350],
                                hintText: 'Enter your new service',
                                labelText: 'Service',
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.black26,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                                suffixIcon: Icon(Icons.design_services,
                                    color: Color(0xff205375)),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (serviceController.text.isEmpty) {
                                  return 'Please enter a service name.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          // child: TextFormField(
                          //   controller: serviceController,
                          //   decoration: const InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     hintText: 'Enter your new service',
                          //     labelText: 'Service',
                          //     suffixIcon: Icon(
                          //       Icons.design_services_rounded,
                          //     ),
                          //   ),
                          //   validator: (value) {
                          //     if (serviceController.text.isEmpty) {
                          //       return 'Please enter a service name.';
                          //     } else {
                          //       return null;
                          //     }
                          //   },
                          // ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        child: SelectWeekDays(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          days: officeHoursDays(user),
                          border: false,
                          boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              colors: [
                                Color(0xff205375),
                                Color(0xff92B4EC),
                              ],
                              tileMode: TileMode
                                  .repeated, // repeats the gradient over the canvas
                            ),
                          ),
                          onSelect: (value) {
                            // <== Callback to handle the selected days
                            List hi = value;
                            List day=[];
                            day.addAll(user.officeHours.keys);
                            for(int i=0; i<hi.length;i++){
                              for(int j=0;j<day.length;j++){
                                if (hi[i].toString().trim()==day[j].toString().trim()){
                                  Map map1 ={ hi[i].toString().trim():user.officeHours[hi[i]].toString()};
                                  days.addAll(map1);
                                }

                              }


                            }
                            print(days);

                            // for (var t in user.officeHours.keys) {
                            //
                            //   //print(value);
                            //   if (i < hi.length) {
                            //     if (t.toString().trim().contains(value[i].toString().trim())
                            //         ) {
                            //       Map map1 ={ value[i].toString():user.officeHours[value[i].toString()].toString()};
                            //       days.addAll(map1);
                            //       //print(days);
                            //     }
                            //
                            //     i++;
                            //   } else {
                            //     break;
                            //   }
                            // }

                            //days = {value: };
                          },
                        ),
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
                                  color: Color(0xff205375),
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
                                      color: Color(0xff205375),
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
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor: Color(0xff205375),
                            iconDisabledColor: Colors.white,
                            buttonHeight: 50,
                            buttonWidth: 500,
                            buttonPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: Colors.grey.shade400,
                            ),
                            buttonElevation: 2,
                            itemHeight: 40,
                            itemPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            dropdownMaxHeight: 200,
                            dropdownPadding: null,
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.grey.shade400,
                            ),
                            dropdownElevation: 8,
                            scrollbarRadius: const Radius.circular(40),
                            scrollbarThickness: 6,
                            scrollbarAlwaysShow: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, top: 0, bottom: 0, right: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            child: Text(
                              "Add",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              final isValid = formKey.currentState!.validate();
                              if (isValid) {
                                setService(
                                  duration: duration!,
                                  service: serviceController.text,
                                  days: days,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: Color(0xff205375),
                              onPrimary: Color(0xff205375),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 150),
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: SizedBox(
                      //       width: 320,
                      //       height: 50,
                      //       child: ElevatedButton(
                      //         style: ButtonStyle(
                      //           backgroundColor:
                      //               MaterialStateProperty.all<Color>(Colors.black),
                      //         ),
                      //         child: const Text(
                      //           'Add',
                      //           style: TextStyle(fontSize: 15),
                      //         ),
                      //         onPressed: () {
                      //           final isValid = formKey.currentState!.validate();
                      //           if (isValid) {
                      //             setService(
                      //               Duration: duration!,
                      //               Service: serviceController.text,
                      //               Time: "$startTime - $endTime",
                      //               days: days,
                      //             );
                      //           }
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            );
          }else
          return Text("data");

          }),
    );
  }

  Future<UserAccount?> readUser() async {
    final getUser =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final snapshot = await getUser.get();
    if (snapshot.exists) {
      return UserAccount.fromJson(snapshot.data()!);
    }
    return null;
  }

  Future setService({
    String? id,
    required String duration,
    required String service,
    required Map days,
  }) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('Service').doc();
      final user = SetEmpService(
        id: currentUser.uid,
        service: service,
        days: days,
        duration: duration,
      );
      final json = user.toJson();
      await docUser.set(json);
      AwesomeDialog(
        autoDismiss: false,
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Success',
        desc: 'Service added successfully',
        btnOkText: "Add more services",
        btnCancelText: 'Go back',
        btnCancelColor: Colors.black87,
        btnOkOnPress: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ServicePage()));
        },
        onDissmissCallback: (d) {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ServicePage()));
        },
        btnCancelOnPress: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationDrawer()));
        },
      ).show();
    } on FirebaseAuthException catch (error) {
      AwesomeDialog(
        autoDismiss: false,
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error',
        desc: '${error.message}',
        btnCancelText: 'Go back',
        btnCancelColor: Colors.black87,
        onDissmissCallback: (d) {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationDrawer()));
        },
        btnCancelOnPress: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationDrawer()));
        },
      ).show();
    }
  }
}
