import 'package:flutter/material.dart';
import 'your_account.dart';

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
          iconTheme: IconThemeData(color: Colors.black),
          leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  width: 330,
                  child: Center(
                    child: const Text(
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
                      padding: EdgeInsets.fromLTRB(0, 40, 16, 0),
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
                                InputDecoration(labelText: 'First Name'),
                            controller: firstNameController,
                          ))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 40, 16, 0),
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
                  padding: EdgeInsets.only(top: 150),
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
                              updateUserValue(firstNameController.text +
                                  " " +
                                  secondNameController.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )))
            ],
          ),
        ));
  }
}

bool isAlpha(String str) {
  RegExp _alpha = RegExp(r'^[a-zA-Z]+$');
  return _alpha.hasMatch(str);
}
