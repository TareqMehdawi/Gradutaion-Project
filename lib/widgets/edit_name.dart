import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/your_account.dart';

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
  var user = UserData.myUser;
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  void updateUserValue(String name) {
    user.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
                width: 330,
                child: Center(
                  child: Text(
                    "What's Your Name?",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
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
                  width: 330,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate() &&
                          isAlpha(firstNameController.text +
                              secondNameController.text)) {
                        updateUserName(name: "${firstNameController.text} ${secondNameController.text}");
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
                            onDissmissCallback: (d){
                              return Navigator.of(context).popUntil((route) => route.isFirst);
                            }
                        ).show();
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future updateUserName({required String name}) async{
    try {
      final docUser = FirebaseFirestore.instance.collection('users').doc(
          currentUser.uid);
      final json = {
        'name': name,
      };
      await docUser.update(json);
    } on FirebaseAuthException catch(error){
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
          onDissmissCallback: (d){
            return Navigator.of(context).popUntil((route) => route.isFirst);
          }
      ).show();
    }
  }
}

bool isAlpha(String str) {
  RegExp _alpha = RegExp(r'^[a-zA-Z]+$');
  return _alpha.hasMatch(str);
}
