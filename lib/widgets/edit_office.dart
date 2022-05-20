import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/your_account.dart';


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
  var user = UserData.myUser;
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    officeController.dispose();
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
                        "What's your office location?",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                                if (value!.isEmpty) {
                                  return 'Please enter your office location.';
                                }else if (!isAlpha(value)) {
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
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  isAlpha(officeController.text)) {
                                updateUserValue(officeController.text);
                                createOfficeField(office: officeController.text.trim());
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        ));
  }
  Future createOfficeField({required String office}) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final json = {
      'office': office,
    };
    await docUser.update(json);
  }
}
bool isAlpha(String str) {
  RegExp _alpha = RegExp(r"^[a-zA-Z0-9]+");
  return _alpha.hasMatch(str);
}