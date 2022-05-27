import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/your_account.dart';

class EditEmailFormPage extends StatefulWidget {
  const EditEmailFormPage({Key? key}) : super(key: key);

  @override
  EditEmailFormPageState createState() {
    return EditEmailFormPageState();
  }
}

class EditEmailFormPageState extends State<EditEmailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  var user = UserData.myUser;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void updateUserValue(String email) {
    user.email = email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
                width: 320,
                child: Center(
                  child: Text(
                    "What's your email?",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff205375),
                    ),
                    textAlign: TextAlign.left,
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    height: 100,
                    width: 320,
                    child: TextFormField(
                      // Handles Form Validation
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email.';
                        } else if (!isAlpha(value)) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Your email address'),
                      controller: emailController,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: editEmailButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget editEmailButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          //focusNode: f3,
          child: Text(
            'Update',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                isAlpha(emailController.text)) {
              updateUserValue(emailController.text);
              Navigator.pop(context);
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
    );
  }
}

bool isAlpha(String str) {
  RegExp alpha = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return alpha.hasMatch(str);
}
