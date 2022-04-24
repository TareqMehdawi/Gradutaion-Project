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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              height: 400,
              color: const Color(0xff141E27),
              child: Center(
                child: Text(
                  'Forgot Password',
                  style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
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
    );
  }

  Widget emailFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.email_outlined),
        ),
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xff141E27),
        minimumSize: Size(MediaQuery.of(context).size.width * .94,
            MediaQuery.of(context).size.height * .08),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(
        'Submit',
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
            fontSize: 22,
              fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onPressed: () async{
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(
              email: emailController.text.trim());

          Utils.showSnackBar('Password Reset Email Sent');
          Navigator.of(context).popUntil((route) => route.isFirst);

        } on FirebaseAuthException catch (error){
          Utils.showSnackBar(error.message);
          Navigator.of(context).pop;
        }
      },
    );
  }
}

