import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPhoneFormPage extends StatefulWidget {
  const EditPhoneFormPage({Key? key}) : super(key: key);

  @override
  EditPhoneFormPageState createState() {
    return EditPhoneFormPageState();
  }
}

class EditPhoneFormPageState extends State<EditPhoneFormPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    phoneController.dispose();
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
                  "What's Your Phone Number?",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff205375)),
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
                          width: 200,
                          child: TextFormField(
                            //keyboardType:,
                            // Handles Form Validation
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              } else if (isAlpha(value)) {
                                return 'Only Numbers Please';
                              } else if (value.length < 10) {
                                return 'Please enter a VALID phone number';
                              }
                              return null;
                            },
                            controller: phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Your Phone Number',
                            ),
                          ))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: editPhoneNumberButton(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future updateUserPhone({required String phoneNumber}) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      final json = {
        'phoneNumber': phoneNumber,
      };
      await docUser.update(json);
      AwesomeDialog(
          autoDismiss: false,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Success',
          desc: 'Phone number changed successfully',
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

  Widget editPhoneNumberButton() {
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
                isNumeric(phoneController.text)) {
              updateUserPhone(phoneNumber: phoneController.text);
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

bool isNumeric(String str) {
  RegExp numeric = RegExp(r'^-?[0-9]+$');
  return numeric.hasMatch(str);
}
