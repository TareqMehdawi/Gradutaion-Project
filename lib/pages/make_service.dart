import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';

import '../widgets/edit_office_time.dart';
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
  bool newDay = false;
  bool selectTime = false;

  Map days = {};
  final currentUser = FirebaseAuth.instance.currentUser!;

  String? time2;

  String? selectedValue;
  List<String> items = [
    '5 minute',
    '10 minute',
    '15 minute',
    '20 minute',
    '25 minute',
    '30 minute',
  ];

  List<DayInWeek> officeHoursDays(UserAccount? user) {
    final List<DayInWeek> days = [];
    List day = [];
    day.addAll(user!.officeHours.keys);
    for (int i = 0; i < day.length; i++) {
      days.add(DayInWeek(day[i].toString()));
    }

    return days;
  }

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
          if (snapshot.hasData) {
            final user = snapshot.data!;
            bool officeHours = user.officeHours.isEmpty;
            if (!officeHours) {
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                              List day = [];
                              day.addAll(user.officeHours.keys);
                              for (int i = 0; i < hi.length; i++) {
                                for (int j = 0; j < day.length; j++) {
                                  if (hi[i].toString().trim() ==
                                      day[j].toString().trim()) {
                                    Map map1 = {
                                      hi[i].toString().trim():
                                          user.officeHours[hi[i]].toString()
                                    };
                                    days.addAll(map1);
                                  }
                                }
                              }
                              newDay = true;
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
                                  selectTime = true;
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
                                final isValid =
                                    formKey.currentState!.validate();
                                if (isValid &&
                                    newDay == true &&
                                    selectTime == true) {
                                  setService(
                                      duration: duration!,
                                      service: serviceController.text,
                                      days: days,
                                      image: user.image);
                                } else {
                                  AwesomeDialog(
                                    autoDismiss: false,
                                    context: context,
                                    dialogType: DialogType.WARNING,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Warning',
                                    desc: 'Please fill all fields',
                                    btnOkText: "Ok",
                                    btnCancelColor: Colors.black87,
                                    btnOkOnPress: () {
                                      Navigator.pop(context);
                                    },
                                    onDissmissCallback: (d) {},
                                  ).show();
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
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.1),
                    child: Image.asset('assets/images/Empty-pana.png'),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Column(
                          children: [
                            Text(
                              "You didn't add any office hours!",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff205375),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 70,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: ElevatedButton(
                                        child: Text(
                                          "Add Office Hours",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditOfficeHoursFormPage()));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 2,
                                          primary: Color(0xff205375),
                                          onPrimary: Color(0xff205375),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          } else
            return splashScreen();
        },
      ),
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
    required String image,
  }) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('Service').doc();
      final user = SetEmpService(
          id: currentUser.uid,
          service: service,
          days: days,
          duration: duration,
          image: image);
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
