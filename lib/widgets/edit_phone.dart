import 'package:flutter/material.dart';
import '../pages/your_account.dart';

// This class handles the Page to edit the Phone Section of the User Profile.
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
  var user = UserData.myUser;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void updateUserValue(String phone) {
    String formattedPhoneNumber = "(" +
        phone.substring(0, 3) +
        ") " +
        phone.substring(3, 6) +
        "-" +
        phone.substring(6, phone.length);
    user.phone = formattedPhoneNumber;
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
          child: ListView(children: <Widget>[
            const SizedBox(
                width: 320,
                child: Center(
                  child: Text(
                    "What's Your Phone Number?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                        width: 200,
                        child: TextFormField(
                          // Handles Form Validation
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
                      width: 320,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              isNumeric(phoneController.text)) {
                            updateUserValue(phoneController.text);
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
}

bool isAlpha(String str) {
  RegExp _alpha = RegExp(r'^[a-zA-Z]+$');
  return _alpha.hasMatch(str);
}

bool isNumeric(String str) {
  RegExp _numeric = RegExp(r'^-?[0-9]+$');
  return _numeric.hasMatch(str);
}
