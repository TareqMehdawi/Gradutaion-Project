import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/login_page.dart';

class EditEmailFormPage extends StatefulWidget {
  final type;

  EditEmailFormPage({Key? key, required this.type}) : super(key: key);

  @override
  EditEmailFormPageState createState() {
    return EditEmailFormPageState();
  }
}

class EditEmailFormPageState extends State<EditEmailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final currentUser = FirebaseAuth.instance.currentUser!;
  TextEditingController emailController = TextEditingController();
  final regEmailDoc = RegExp(
      r"^((?!Reg)|(?!reg))[a-zA-Z]+\.[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@ju\.edu\.jo");
  final regEmailReg = RegExp(
      r"^((Reg)|(reg))\.[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@ju\.edu\.jo");
  bool showValidate = false;
  TextEditingController currentPasswordController = TextEditingController();
  bool showPassword = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
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
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "What's your new email?",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xff205375),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Form(
            key: _formKey,
            autovalidateMode: showValidate == true
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    height: 80,
                    width: 320,
                    child: TextFormField(
                      controller: emailController,
                      // Handles Form Validation
                      validator: (value) {
                        if (widget.type == 'doctor') {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!regEmailDoc.hasMatch(value)) {
                            return 'Please enter a valid email';
                          } else if (currentUser.email ==
                              emailController.text.trim()) {
                            return "The new email can't be the same as the old email";
                          }
                        } else if (widget.type == 'registration') {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (currentUser.email ==
                              emailController.text.trim()) {
                            return "The new email can't be the same as the old email";
                          } else if (!regEmailReg.hasMatch(value)) {
                            return 'please enter a valid email';
                          }
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Your email address'),
                    ),
                  ),
                ),
                passwordFormField(),
                checkBoxWidget(),
              ],
            ),
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
    );
  }

  Widget passwordFormField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: SizedBox(
        height: 80,
        width: 320,
        child: TextFormField(
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(labelText: 'Your password'),
          controller: currentPasswordController,
          obscureText: !showPassword,
          validator: (value) {
            final regPassword = RegExp(
                "^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[_!@#\$%^&*(),.?:{}|<>]).*");
            if (value!.isEmpty) {
              return 'Enter a password';
            } else if (!regPassword.hasMatch(value)) {
              return "Password don't match";
            }
            return null;
          },
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }

  Widget checkBoxWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: CheckboxListTile(
        value: showPassword,
        title: const Text(
          'Show password',
          style: TextStyle(color: Colors.black54),
        ),
        secondary: Icon(showPassword == false
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined),
        onChanged: (value) {
          setState(() {
            showPassword = value!;
          });
        },
        contentPadding: const EdgeInsets.only(left: 7),
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
          child: Text(
            'Update',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            setState(() {
              showValidate = true;
            });
            final isValid = _formKey.currentState!.validate();
            if (isValid) {
              _formKey.currentState?.save();
              try {
                var result = await currentUser.reauthenticateWithCredential(
                  EmailAuthProvider.credential(
                    email: currentUser.email!,
                    password: currentPasswordController.text.trim(),
                  ),
                );
                final docUser = FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid);
                final json = {
                  'email': emailController.text.trim(),
                };
                await result.user?.updateEmail(emailController.text.trim());
                await docUser.update(json);
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
                AwesomeDialog(
                    autoDismiss: false,
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Success',
                    desc: 'Email changed successfully',
                    btnOkText: "Ok",
                    btnOkOnPress: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    onDissmissCallback: (d) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    }).show();
              } on FirebaseAuthException catch (error) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Warning',
                  desc: '${error.message}',
                  btnOkText: "Ok",
                  btnOkOnPress: () {},
                  btnCancelOnPress: () {
                    Navigator.pop(context);
                  },
                ).show();
                // Utils.showSnackBar(error.message);
              }
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
