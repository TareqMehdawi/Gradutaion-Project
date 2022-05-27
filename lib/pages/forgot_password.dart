import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/widgets/utils_show_snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final regEmailStu = RegExp(r"^[a-zA-Z]{3}[0-9]{7}@ju\.edu\.jo");
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
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
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      iconSize: 30.0,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xff205375),
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      child: Image.asset(
                        'assets/images/Forgot password.png',
                        scale: 2.5,
                        width: 280,
                        height: 280,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 25),
                      child: Text(
                        'Forgot Password',
                        style: GoogleFonts.lato(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  emailFormField(),
                  const SizedBox(
                    height: 15,
                  ),
                  submitButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emailFormField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: TextFormField(
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
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter an email';
          } else {
            return 'Please enter a valid email!';
          }
        },
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
    //   child: TextFormField(
    //     controller: emailController,
    //     keyboardType: TextInputType.emailAddress,
    //     decoration: const InputDecoration(
    //       labelText: 'Email',
    //       border: OutlineInputBorder(),
    //       suffixIcon: Icon(Icons.email_outlined),
    //     ),
    //   ),
    // );
  }

  Widget submitButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          child: Text(
            'Submit',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            try {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: emailController.text.trim());

              Utils.showSnackBar('Password Reset Email Sent');
              Navigator.of(context).popUntil((route) => route.isFirst);
            } on FirebaseAuthException catch (error) {
              Utils.showSnackBar(error.message);
              Navigator.of(context).pop;
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
    // return ElevatedButton(
    //   style: OutlinedButton.styleFrom(
    //     backgroundColor: const Color(0xff141E27),
    //     minimumSize: Size(MediaQuery.of(context).size.width * .94,
    //         MediaQuery.of(context).size.height * .08),
    //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(18),
    //     ),
    //   ),
    //   child: Text(
    //     'Submit',
    //     style: GoogleFonts.ubuntu(
    //       textStyle: const TextStyle(
    //         fontSize: 22,
    //           fontWeight: FontWeight.w500,
    //       ),
    //     ),
    //   ),
    //   onPressed: () async{
    //     try {
    //       await FirebaseAuth.instance.sendPasswordResetEmail(
    //           email: emailController.text.trim());
    //
    //       Utils.showSnackBar('Password Reset Email Sent');
    //       Navigator.of(context).popUntil((route) => route.isFirst);
    //
    //     } on FirebaseAuthException catch (error){
    //       Utils.showSnackBar(error.message);
    //       Navigator.of(context).pop;
    //     }
    //   },
    // );
  }
}
