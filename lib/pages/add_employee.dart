import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/user_class.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final formKey = GlobalKey<FormState>();
  bool showValidate = false;
  String? selectedValue;
  FocusNode f1 = new FocusNode();
  FocusNode f2 = new FocusNode();
  FocusNode f3 = new FocusNode();
  FocusNode f4 = new FocusNode();
  String imgUrl = '';
  String? type;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final regEmailDoc = RegExp(
      r"^((?!Reg)|(?!reg))[a-zA-Z]+\.[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@ju\.edu\.jo");
  final regEmailReg = RegExp(
      r"^((Reg)|(reg))\.[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@ju\.edu\.jo");
  List<String> items = [
    'registration',
    ' doctor',
  ];

  @override
  void initState() {
    getImageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Employee'),
          centerTitle: true,
          backgroundColor: Color(0xff205375),
        ),
        body: Form(
          key: formKey,
          autovalidateMode: showValidate == true
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Stack(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "assets/images/bottom_left.png",
                    width: MediaQuery.of(context).size.width * .3,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: Image.asset(
                      'assets/images/Admin.png',
                      scale: 2.5,
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
                usernameFormField(),
                const SizedBox(
                  height: 12,
                ),
                emailFormField(),
                const SizedBox(
                  height: 12,
                ),
                passwordFormField(),
                const SizedBox(
                  height: 12,
                ),
                confirmPasswordFormField(),
                const SizedBox(
                  height: 12,
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Icon(
                            Icons.list,
                            size: 16,
                            color: Color(0xff205375),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              'Select type of employee',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff205375),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                          type = value;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Color(0xff205375),
                      iconDisabledColor: Colors.white,
                      buttonHeight: 50,
                      buttonWidth: 500,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.grey.shade400,
                      ),
                      buttonElevation: 2,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Color(0xff205375),
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                registerButton(),
              ]),
            )
          ]),
        ));
  }

  Widget usernameFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        focusNode: f1,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        keyboardType: TextInputType.emailAddress,
        controller: usernameController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[350],
          hintText: 'Employee Name',
          hintStyle: GoogleFonts.lato(
            color: Colors.black26,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          suffixIcon:
              Icon(Icons.person_outline_rounded, color: Color(0xff205375)),
        ),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          f1.unfocus();
          FocusScope.of(context).requestFocus(f2);
        },
        validator: (value) {
          final regUsername = RegExp(r'^[a-zA-Z-\. ]{2,30}$');
          if (value!.isEmpty) {
            return 'Enter an username';
          } else if (value.length < 3) {
            return 'Enter at least 3 characters!';
          } else if (!regUsername.hasMatch(value)) {
            return 'Username can only have letters!';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget emailFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        focusNode: f2,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[350],
          hintText: 'Email',
          hintStyle: GoogleFonts.lato(
            color: Colors.black26,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          suffixIcon: Icon(Icons.email_outlined, color: Color(0xff205375)),
        ),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          f2.unfocus();
          FocusScope.of(context).requestFocus(f3);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter an email';
          } else if (regEmailReg.hasMatch(value)) {
            type = 'registration';
          } else if (regEmailDoc.hasMatch(value)) {
            type = 'doctor';
          } else {
            return 'Please enter a valid email!';
          }
          return null;
        },
      ),
    );
  }

  Widget passwordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
          focusNode: f3,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[350],
            hintText: 'Password',
            hintStyle: GoogleFonts.lato(
              color: Colors.black26,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
            suffixIcon: Icon(
              Icons.lock_outline,
              color: Color(0xff205375),
            ),
          ),
          obscureText: true,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            f3.unfocus();
            FocusScope.of(context).requestFocus(f4);
          },
          validator: (value) {
            final regPassword = RegExp(
                "^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[_!@#\$%^&*(),.?:{}|<>]).*");
            if (value!.isEmpty) {
              return 'Enter a password';
            } else if (!regPassword.hasMatch(value)) {
              return 'Password must have at least:\nOne upper case,\nOne lower case,\nOne digit,\nOne special character,\nMinimum eight characters,';
            } else {
              return null;
            }
          }),
    );
  }

  Widget confirmPasswordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        focusNode: f4,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        controller: confirmPassword,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[350],
          hintText: 'Confirm Password',
          hintStyle: GoogleFonts.lato(
            color: Colors.black26,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          suffixIcon: Icon(
            Icons.lock_outline,
            color: Color(0xff205375),
          ),
        ),
        obscureText: true,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (passwordController.text.trim() != confirmPassword.text.trim()) {
            return 'Password doesn\'t match';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget registerButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          focusNode: f3,
          child: Text(
            'Add Employee',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            final isValid = formKey.currentState!.validate();
            FocusScope.of(context).unfocus();
            setState(() {
              showValidate = true;
            });
            if (isValid) {
              formKey.currentState?.save();
              final username = usernameController.text;
              //final phoneNumber = phoneNumberController.text;

              // setState(() {
              //   isLoading = true;
              // });
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
                final user2 = FirebaseAuth.instance.currentUser!.uid;

                var rng = Random();
                String ran = rng.nextInt(1000).toString();
                String id = ran + user2;

                //saveData(emailController.text, passwordController.text, 'true');
                createEmployee(
                    name: username,
                    number: "phone number",
                    email: emailController.text,
                    type: type!,
                    id: user2);
                AwesomeDialog(
                    autoDismiss: false,
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Success',
                    desc: 'Account successfully created',
                    btnOkText: "Ok",
                    btnOkOnPress: () {
                      Navigator.pop(context);
                    },
                    onDissmissCallback: (d) {
                      Navigator.pop(context);
                    }).show();
              } on FirebaseAuthException catch (error) {
                // Utils.showSnackBar(error.message);
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Warning',
                  desc: '${error.message}',
                  btnCancelText: "Cancel",
                  btnOkText: "Ok",
                  btnOkOnPress: () {},
                  btnCancelOnPress: () {},
                ).show();
              }
              // setState(() {
              //   isLoading = false;
              // });
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

  Future createEmployee({
    required String name,
    required String number,
    required String email,
    required String type,
    required String id,
    String office = 'Office location',
  }) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    final user = UserAccount(
      id: docUser.id,
      name: name,
      number: number,
      email: email,
      image: imgUrl,
      type: type,
      office: office,
      officeHours: {},
      notificationCounter: 0,
    );

    final json = user.toJson();

    await docUser.set(json);
  }

  getImageData() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('userImage')
        .child('default_image.png');
    imgUrl = await ref.getDownloadURL();
  }
}
