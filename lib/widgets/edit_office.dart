import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditOfficeFormPage extends StatefulWidget {
  const EditOfficeFormPage({Key? key}) : super(key: key);

  @override
  EditOfficeFormPageState createState() {
    return EditOfficeFormPageState();
  }
}

class EditOfficeFormPageState extends State<EditOfficeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final officeController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    officeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Account',
        ),
        centerTitle: true,
        backgroundColor: Color(0xff205375),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "What's your office location?",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff205375)),
                textAlign: TextAlign.left,
              ),
            ),
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
                            if (value!.isEmpty) {
                              return 'Please enter your office location.';
                            } else if (!isAlpha(value)) {
                              return 'Enter a valid office location!';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Your office location '),
                          controller: officeController,
                        ))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 320,
                  height: 50,
                  child: editOfficeButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future createOfficeField({required String office}) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final json = {
      'office': office,
    };
    await docUser.update(json);
  }

  Widget editOfficeButton() {
    return SizedBox(
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
              isAlpha(officeController.text)) {
            createOfficeField(office: officeController.text.trim());
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
    );
  }
}

bool isAlpha(String str) {
  RegExp alpha = RegExp(r"^[a-zA-Z0-9]+");
  return alpha.hasMatch(str);
}
