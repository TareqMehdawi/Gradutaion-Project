import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/employee_page.dart';
import 'package:graduation_project/pages/feedback_page.dart';
import 'package:graduation_project/pages/make_reservations.dart';
import 'package:graduation_project/pages/settings_page.dart';
import 'package:graduation_project/pages/student_page.dart';
import 'package:graduation_project/pages/your_account.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

String image = 'assets/images/images.png';

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
   const NavigationDrawer({Key? key}) : super(key: key);



  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {

  final user = FirebaseAuth.instance.currentUser!;
  bool isEmployee = true;
  GetPage get =  GetPage();

  @override
  Widget build(BuildContext context) {
    double value = Provider.of<NavigationProvider>(context).value;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .1,
            decoration: const BoxDecoration(
              color: Color(0xff141E27),
            ),
          ),
          SizedBox(
            width: 220,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .25,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xff141E27),
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
                          backgroundImage: AssetImage(image),
                        ),
                        const SizedBox(
                          height: 10.0,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FittedBox(
                            child: Text(
                              user.email.toString(),
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
                              Provider.of<NavigationProvider>(context, listen: false).changeValue();
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const StudentPage(),
                              ),
                            );
                          }
                        },
                      ),
                      drawerTiles(
                        icon: Icons.account_circle_rounded,
                        title: 'Your Account',
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  const YourAccount(),
                            ),
                          );
                        },
                      ),
                      drawerTiles(
                        icon: Icons.people,
                        title: 'People',
                        function: () {
                        },
                      ),
                      drawerTiles(
                        icon: Icons.connect_without_contact,
                        title: 'Make Reservations',
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const ReservationPage(),
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
                        icon: Icons.feedback,
                        title: 'Feedback',
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const FeedbackPage(),
                            ),
                          );
                        },
                      ),
                      drawerTiles(
                        icon: Icons.logout,
                        title: 'Logout',
                        function: () {
                          setState(() {
                            Provider.of<NavigationProvider>(context, listen: false).value = 0;
                          });
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                              const LoginPage(),
                            ),
                          );
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
                  child: isEmployee == get.checkEmail() ? const EmployeePage() : const StudentPage(),
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
      ),
    );
  }

  Widget drawerTiles({
    required IconData icon,
    required String title,
    required VoidCallback function,
  }) {
    return ListTile(
      selectedTileColor: const Color(0xff141E27),
      onTap: function,
      leading: Icon(
        icon,
        color: const Color(0xff141E27),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xff141E27)),
      ),
    );
  }
}
