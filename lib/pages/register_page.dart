import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/pages/login_page.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';
import 'package:graduation_project/widgets/user_class.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  FocusNode f1 = new FocusNode();
  FocusNode f2 = new FocusNode();
  FocusNode f3 = new FocusNode();
  FocusNode f4 = new FocusNode();
  FocusNode f5 = new FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool showValidate = false;
  bool showPassword = false;
  bool isLoading = false;
  String? type;
  String imgUrl = '';

  final regEmailDoc = RegExp(
      r"^((?!Reg)|(?!reg))[a-zA-Z]+\.[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@ju\.edu\.jo");
  final regEmailReg = RegExp(
      r"^((Reg)|(reg))\.[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@ju\.edu\.jo");
  final regEmailStu = RegExp(r"^[a-zA-Z]{3}[0-9]{7}@ju\.edu\.jo");

  @override
  void initState() {
    getImageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? splashScreen()
        : Scaffold(
            body: Form(
              key: formKey,
              autovalidateMode: showValidate == true
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          "assets/images/top_right.png",
                          width: MediaQuery.of(context).size.width * .3,
                        ),
                      ),
                    ],
                  ),
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
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            child: Image.asset(
                              'assets/images/Sign up.png',
                              scale: 2.5,
                              width: 250,
                              height: 250,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 25),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.lato(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
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
                        phoneFormField(),
                        const SizedBox(
                          height: 12,
                        ),
                        passwordFormField(),
                        const SizedBox(
                          height: 12,
                        ),
                        confirmPasswordFormField(),
                        checkBoxWidget(),
                        registerButton(),
                        const SizedBox(
                          height: 12,
                        ),
                        loginButton(),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
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
          hintText: 'Username',
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
          final regUsername = RegExp(r'^[a-zA-Z ]{2,30}$');
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
          } else if (regEmailStu.hasMatch(value)) {
            type = 'student';
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

  Widget phoneFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        focusNode: f3,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        controller: phoneNumberController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[350],
          hintText: 'Phone Number',
          hintStyle: GoogleFonts.lato(
            color: Colors.black26,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          suffixIcon: Icon(
            Icons.phone_outlined,
            color: Color(0xff205375),
          ),
        ),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          f3.unfocus();
          FocusScope.of(context).requestFocus(f4);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter a phone number';
            //////////////////////////////////
          } else if (value.length > 10) {
            return 'Enter a valid phone number!';
          } else if (value.length < 10) {
            return 'Enter a valid phone number!';
          } else {
            ///////////////////////////////////////////
            return null;
          }
        },
      ),
    );
  }

  Widget passwordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
          focusNode: f4,
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
          obscureText: !showPassword,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            f4.unfocus();
            FocusScope.of(context).requestFocus(f5);
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
        focusNode: f5,
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
        obscureText: !showPassword,
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

  Widget registerButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          focusNode: f3,
          child: Text(
            'Register',
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
              final phoneNumber = phoneNumberController.text;

              setState(() {
                isLoading = true;
              });
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim());
                final user = FirebaseAuth.instance.currentUser!;
                if (type == 'student') {
                  createUser(
                      name: username,
                      number: phoneNumber,
                      id: user.uid,
                      email: emailController.text,
                      type: type!);
                } else {
                  createEmployee(
                      name: username,
                      number: phoneNumber,
                      id: user.uid,
                      email: emailController.text,
                      type: type!);
                }
                AwesomeDialog(
                    autoDismiss: false,
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Success',
                    desc: 'Account successfully created',
                    btnOkText: "Ok",
                    btnOkOnPress: () {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigationDrawer(),
                        ),
                      );
                    },
                    onDissmissCallback: (d) {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigationDrawer(),
                        ),
                      );
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
              setState(() {
                isLoading = false;
              });
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

  Widget loginButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          child: Text(
            "Log in",
            style: GoogleFonts.lato(
              color: Color(0xff205375),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 2,
            primary: Colors.grey.shade400,
            onPrimary: Color(0xff205375),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      ),
    );
  }

  Future createUser(
      {required String name,
      required String number,
      required String id,
      required String email,
      required String type}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);

    final user = Users(
      id: docUser.id,
      name: name,
      number: number,
      email: email,
      image: imgUrl,
      type: type,
      notificationCounter: 0,
    );

    final json = user.toJson();

    await docUser.set(json);
  }

  Future createEmployee({
    required String name,
    required String number,
    required String id,
    required String email,
    required String type,
    String office = 'Office no.',
    String workingHours = 'Nothing to show..',
  }) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    final user = UserAccount(
      id: docUser.id,
      name: name,
      number: number,
      email: email,
      image: imgUrl,
      type: type,
      office: 'Office No.',
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
