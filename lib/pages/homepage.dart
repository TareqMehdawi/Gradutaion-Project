import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';
import 'package:graduation_project/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    checkIsLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/t.png",
              width: MediaQuery.of(context).size.width * .3,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "assets/images/bottom_right.png",
                width: MediaQuery.of(context).size.width * .3,
              ),
            ),
          ],
        ),
        SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 120,
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Image.asset(
                'assets/images/logo.png',
                scale: 2.5,
                width: 250,
                height: 250,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: Text(
                  "Login",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
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
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: Text(
                  "Sign Up",
                  style: GoogleFonts.lato(
                    color: Color(0xff205375),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  primary: Colors.grey.shade400,
                  onPrimary: Color(0xff205375),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
            ),
          ),
        ]))
      ]),
    );
  }

  checkIsLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var _email = preferences.getString("EMAIL");
    var _password = preferences.getString("PASSWORD");

    if (_email != "" &&
        _email != null &&
        _password != "" &&
        _password != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigationDrawer()));
    } else {
      print("no login.");
    }
  }
}
