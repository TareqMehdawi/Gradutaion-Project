import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/pages/employee_account.dart';
import 'package:graduation_project/pages/employee_page.dart';
import 'package:graduation_project/pages/feedback_page.dart';
import 'package:graduation_project/pages/homepage.dart';
import 'package:graduation_project/pages/make_service.dart';
import 'package:graduation_project/pages/settings_page.dart';
import 'package:graduation_project/pages/student_page.dart';
import 'package:graduation_project/pages/your_account.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/local_notification_service.dart';
import '../widgets/search_delegate_employee.dart';
import '../widgets/user_class.dart';
import 'employee_services.dart';
import 'notifications.dart';

class NavigationProvider extends ChangeNotifier {
  double value;

  NavigationProvider({this.value = 0});

  void changeValue() {
    if (value == 0) {
      value = 1;
      notifyListeners();
    } else {
      value = 0;
      notifyListeners();
    }
  }
}

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  bool isEmployee = true;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String imgUrl = '';
  int? notificationCounter;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  var token;
  double? value;

  @override
  void initState() {
    readUser();
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {}
      LocalNotificationService.display(message);
      notificationCounter = (notificationCounter! + 1);
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      final json = {
        'notificationCounter': notificationCounter,
      };
      await docUser.update(json);
    });
  }

  @override
  Widget build(BuildContext context) {
    value = Provider.of<NavigationProvider>(context).value;
    return Scaffold(
      body: FutureBuilder<Users?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              AwesomeDialog(
                  autoDismiss: false,
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Error',
                  desc: '${snapshot.error}',
                  btnOkText: "Ok",
                  btnOkOnPress: () {
                    FirebaseAuth.instance.signOut();
                  },
                  onDissmissCallback: (d) {
                    FirebaseAuth.instance.signOut();
                  }).show();
              return const Text('Something went wrong');
            } else if (snapshot.hasData) {
              final user = snapshot.data;
              notificationCounter = user?.notificationCounter;
              return Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .1,
                    decoration: const BoxDecoration(
                      color: Color(0xff205375),
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .28,
                          child: DrawerHeader(
                            decoration: const BoxDecoration(
                              color: Color(0xff205375),
                              // border: Border(
                              //   bottom: Divider.createBorderSide(
                              //     context,
                              //     color: const Color(0xff141E27),
                              //   ),
                              // ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(user!.image),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                  width: double.infinity,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: FittedBox(
                                    child: Text(
                                      user.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            children: [
                              drawerTiles(
                                icon: Icons.home,
                                title: 'Home',
                                function: () {
                                  if (value == 1) {
                                    setState(() {
                                      Provider.of<NavigationProvider>(context,
                                              listen: false)
                                          .changeValue();
                                    });
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudentPage(
                                          stdName: user.name,
                                          stdImage: user.image,
                                          type: user.type,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              drawerTiles(
                                icon: Icons.account_circle_rounded,
                                title: 'Your Account',
                                function: () {
                                  setState(() {
                                    Provider.of<NavigationProvider>(context,
                                            listen: false)
                                        .value = 0;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          user.type == 'student'
                                              ? const StudentAccount()
                                              : const EmployeeAccount(),
                                    ),
                                  );
                                },
                              ),
                              user.type == 'student'
                                  ? SizedBox.shrink()
                                  : drawerTiles(
                                      icon: Icons.book,
                                      title: 'My Services',
                                      function: () {
                                        setState(() {
                                          Provider.of<NavigationProvider>(
                                                  context,
                                                  listen: false)
                                              .value = 0;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MyServices(),
                                          ),
                                        );
                                        // await showSearch(context: context,
                                        //     delegate: EmployeeSearchDelegate());
                                      },
                                    ),
                              // Text(
                              //   '',
                              //   style: TextStyle(fontSize: 0),
                              // )
                              user.type == 'student'
                                  ? drawerTiles(
                                      icon: Icons.connect_without_contact,
                                      title: 'Make Reservations',
                                      function: () async {
                                        setState(() {
                                          Provider.of<NavigationProvider>(
                                                  context,
                                                  listen: false)
                                              .value = 0;
                                        });
                                        buildBottomSheet(
                                            stdName: user.name,
                                            stdImage: user.image);
                                      },
                                    )
                                  : drawerTiles(
                                      icon: Icons.add_circle,
                                      title: 'Add Services',
                                      function: () {
                                        setState(() {
                                          Provider.of<NavigationProvider>(
                                                  context,
                                                  listen: false)
                                              .value = 0;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ServicePage(),
                                          ),
                                        );
                                      },
                                    ),
                              const Divider(
                                color: Color(0xff141E27),
                              ),
                              drawerTiles(
                                icon: Icons.settings,
                                title: 'Settings',
                                function: () {
                                  setState(() {
                                    Provider.of<NavigationProvider>(context,
                                            listen: false)
                                        .value = 0;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsPage(),
                                    ),
                                  );
                                },
                              ),
                              drawerTiles(
                                icon: Icons.notifications,
                                title: 'Notifications',
                                function: () async {
                                  setState(() {
                                    Provider.of<NavigationProvider>(context,
                                            listen: false)
                                        .value = 0;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserNotifications(),
                                    ),
                                  );
                                  final docUser = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.uid);
                                  final json = {
                                    'notificationCounter': 0,
                                  };
                                  await docUser.update(json);
                                },
                              ),
                              drawerTiles(
                                icon: Icons.feedback,
                                title: 'Feedback',
                                function: () {
                                  setState(() {
                                    Provider.of<NavigationProvider>(context,
                                            listen: false)
                                        .value = 0;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FeedbackPage(),
                                    ),
                                  );
                                },
                              ),
                              // drawerTiles(
                              //   icon: Icons.create,
                              //   title: 'Admin',
                              //   function: () {
                              //     setState(() {
                              //       Provider.of<NavigationProvider>(context,
                              //               listen: false)
                              //           .value = 0;
                              //     });
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => const AdminPage(),
                              //       ),
                              //     );
                              //   },
                              // ),
                              drawerTiles(
                                icon: Icons.logout,
                                title: 'Logout',
                                function: () async {
                                  Provider.of<NavigationProvider>(context,
                                          listen: false)
                                      .value = 0;
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  await preferences.remove("EMAIL");
                                  await preferences.remove("PASSWORD");
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: value),
                      duration: const Duration(milliseconds: 300),
                      builder: (_, double val, __) {
                        return (Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..setEntry(0, 3, 200 * val)
                            ..rotateY((pi / 7) * val),
                          child: user.type == 'student'
                              ? StudentPage(
                                  stdName: user.name,
                                  stdImage: user.image,
                                  type: user.type)
                              : EmployeePage(type: user.type),
                        ));
                      }),
                  GestureDetector(
                    onHorizontalDragUpdate: (v) {
                      if (v.delta.dx > 0) {
                        setState(() {
                          Provider.of<NavigationProvider>(context,
                                  listen: false)
                              .value = 1;
                        });
                      } else {
                        setState(() {
                          Provider.of<NavigationProvider>(context,
                                  listen: false)
                              .value = 0;
                        });
                      }
                    },
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return splashScreen();
            } else {
              return GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: splashScreen(),
              );
            }
          }),
    );
  }

  updateToken() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var notification = preferences.getString("NOTIFICATION");
      if (notification == "true") {
        await _fcm.getToken().then((currentToken) {
          setState(() {
            token = currentToken;
          });
        });
      } else {
        setState(() {
          token = "null";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future buildBottomSheet({required String stdName, required stdImage}) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
          child: ListView(
            children: [
              const Center(
                child: Text(
                  "Choose who you want to meet:",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  loginButton(
                    title: 'Doctor',
                    function: () async {
                      Navigator.pop(context);
                      await showSearch(
                        context: context,
                        delegate: EmployeeSearchDelegate(
                          type: 'doctor',
                          stdName: stdName,
                          stdImage: stdImage,
                        ),
                      );
                    },
                  ),
                  loginButton(
                    title: 'Registration',
                    function: () async {
                      Navigator.pop(context);
                      await showSearch(
                        context: context,
                        delegate: EmployeeSearchDelegate(
                          type: 'registration',
                          stdName: stdName,
                          stdImage: stdImage,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton({required String title, required VoidCallback function}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * .35,
            MediaQuery.of(context).size.height * .06),
        side: const BorderSide(width: 1, color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: function,
      child: Text(
        title,
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Future<Users?> readUser() async {
    final getUser =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final snapshot = await getUser.get();
    if (snapshot.exists) {
      return Users.fromJson(snapshot.data()!);
    }
    return null;
  }

  Widget drawerTiles({
    required IconData icon,
    required String title,
    required VoidCallback function,
  }) {
    return ListTile(
      selectedTileColor: const Color(0xff92B4EC),
      onTap: function,
      leading: title == "Notifications"
          ? notificationCounter != 0
              ? Badge(
                  badgeContent: Text(
                    '$notificationCounter',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xff205375),
                  ),
                )
              : Icon(
                  icon,
                  color: const Color(0xff205375),
                )
          : Icon(
              icon,
              color: const Color(0xff205375),
            ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
