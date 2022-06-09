import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/add_employee.dart';
import 'package:graduation_project/pages/admin_feedback_page.dart';
import 'package:graduation_project/pages/login_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        centerTitle: true,
        backgroundColor: Color(0xff205375),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          adminButton(
            title: "Add Employee",
            function: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEmployee(),
                ),
              );
            },
          ),
          // adminButton(
          //   title: "Add Admin",
          //   function: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const AddEmployee(),
          //       ),
          //     );
          //   },
          // ),
          adminButton(
            title: "Feedbacks",
            function: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminFeedback(),
                ),
              );
            },
          ),
          adminButton(
            title: "Log out",
            function: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget adminButton({required String title, required VoidCallback function}) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, bottom: 0, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          child: Text(
            title,
            style: GoogleFonts.lato(
              color: Color(0xff205375),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: function,
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
    );
  }
}
