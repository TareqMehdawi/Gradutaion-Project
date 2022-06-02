import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditNameFormPage extends StatefulWidget {
  const EditNameFormPage({Key? key}) : super(key: key);

  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
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
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "What's Your Name?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff205375),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: SizedBox(
                        height: 100,
                        width: 150,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            } else if (!isAlpha(value)) {
                              return 'Only Letters Please';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'First Name'),
                          controller: firstNameController,
                        ))),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: SizedBox(
                        height: 100,
                        width: 150,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            } else if (!isAlpha(value)) {
                              return 'Only Letters Please';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                          controller: secondNameController,
                        )))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: editNameButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future updateUserName({required String name}) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      final json = {
        'name': name,
      };
      await docUser.update(json);
      AwesomeDialog(
          autoDismiss: false,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Success',
          desc: 'Name changed successfully',
          btnOkText: "Ok",
          btnOkOnPress: () {
            return Navigator.of(context).popUntil((route) => route.isFirst);
          },
          onDissmissCallback: (d) {
            return Navigator.of(context).popUntil((route) => route.isFirst);
          }).show();
    } on FirebaseAuthException catch (error) {
      AwesomeDialog(
          autoDismiss: false,
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error',
          desc: '${error.message}',
          btnOkText: "Ok",
          btnOkOnPress: () {
            return Navigator.of(context).popUntil((route) => route.isFirst);
          },
          onDissmissCallback: (d) {
            return Navigator.of(context).popUntil((route) => route.isFirst);
          }).show();
    }
  }

  Widget editNameButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          //focusNode: f3,
          child: Text(
            "Update",
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate() &&
                isAlpha(firstNameController.text.trim() +
                    secondNameController.text.trim())) {
              updateUserName(
                  name:
                      "${firstNameController.text.trim()} ${secondNameController.text.trim()}");
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
  RegExp alpha = RegExp(r'^[a-zA-Z]+$');
  return alpha.hasMatch(str);
}
