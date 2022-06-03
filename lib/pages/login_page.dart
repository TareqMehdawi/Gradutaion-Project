import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/forgot_password.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode f1 = new FocusNode();
  FocusNode f2 = new FocusNode();
  FocusNode f3 = new FocusNode();

  bool showPassword = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isStudent = false;
  final regEmailEmp = RegExp(
      r"^[a-zA-Z]+\.[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@ju\.edu\.jo");
  final regEmailStu = RegExp(r"^[a-zA-Z]{3}[0-9]{7}@ju\.edu\.jo");

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? splashScreen()
        : Scaffold(
            body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                } else if (snapshot.hasData) {
                  saveData(emailController.text, passwordController.text);
                  return const NavigationDrawer();
                } else {
                  return Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/t.png",
                            width: MediaQuery.of(context).size.width * .3,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(
                              "assets/images/bottom_right.png",
                              width: MediaQuery.of(context).size.width * .3,
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                child: Image.asset(
                                  'assets/images/login_page.png',
                                  scale: 2.5,
                                  width: 250,
                                  height: 250,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 25),
                              child: Text(
                                'Login',
                                style: GoogleFonts.lato(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            emailFormField(),
                            const SizedBox(
                              height: 12,
                            ),
                            passwordFormField(),
                            checkBoxWidget(),
                            loginButton(),
                            const SizedBox(
                              height: 12,
                            ),
                            buildForgetPassword(),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          );
  }

  Widget emailFormField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: TextFormField(
        focusNode: f1,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
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
          f1.unfocus();
          FocusScope.of(context).requestFocus(f2);
        },
      ),
    );
  }

  Widget passwordFormField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: TextFormField(
        focusNode: f2,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        //keyboardType: TextInputType.visiblePassword,
        controller: passwordController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
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
        onFieldSubmitted: (value) {
          f2.unfocus();
          FocusScope.of(context).requestFocus(f3);
        },
        obscureText: !showPassword,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget checkBoxWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
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

  Widget loginButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          focusNode: f3,
          child: Text(
            "Login",
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim());
              if (regEmailStu.hasMatch(emailController.text.trim())) {
                saveData(emailController.text, passwordController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NavigationDrawer(),
                  ),
                );
              } else if (regEmailEmp.hasMatch(emailController.text.trim())) {
                saveData(emailController.text, passwordController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NavigationDrawer(),
                  ),
                );
              }
            } on FirebaseAuthException catch (e) {
              // Utils.showSnackBar('Wrong Email or Password!');
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Warning',
                desc: '${e.message}',
                btnCancelText: "Cancel",
                btnOkText: "Ok",
                btnOkOnPress: () {},
                btnCancelOnPress: () {},
              ).show();
            }
            setState(() {
              isLoading = false;
            });
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

  // Widget registerButton() {
  //   return Container(
  //     padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
  //     child: SizedBox(
  //       width: double.infinity,
  //       height: 50,
  //       child: ElevatedButton(
  //         focusNode: f3,
  //         child: Text(
  //           "Sign Up",
  //           style: GoogleFonts.lato(
  //             color: Color(0xff205375),
  //             fontSize: 18.0,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         onPressed: () async {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const RegisterPage(),
  //               ));
  //         },
  //         style: ElevatedButton.styleFrom(
  //           elevation: 2,
  //           primary: Colors.grey.shade400,
  //           onPrimary: Color(0xff205375),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(32.0),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //
  // }

  Widget buildForgetPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: GestureDetector(
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Forgot Password? ',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: 'Click here!',
                style: TextStyle(
                  color: Color(0xFF144BAC),
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ForgotPassword(),
            ),
          );
        },
      ),
    );
  }

  saveData(String email, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("EMAIL", email);
    preferences.setString("PASSWORD", password);
  }
}
