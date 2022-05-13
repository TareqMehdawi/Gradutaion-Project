import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/forgot_password.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';
import 'package:graduation_project/pages/register_page.dart';
import 'package:graduation_project/widgets/spinKit_widget.dart';

import '../widgets/utils_show_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false ;
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
    return isLoading == true ? const SpinKitWidget() : Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
           if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else if (snapshot.hasData) {
            return const NavigationDrawer();
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    height: 300,
                    color: const Color(0xff141E27),
                    child: Center(
                      child: Text(
                        'Login',
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
                    height: 12,
                  ),
                  passwordFormField(),
                  checkBoxWidget(),
                  loginButton(),
                  const SizedBox(
                    height: 12,
                  ),
                  registerButton(),
                  buildForgetPassword(),
                ],
              ),
            );
          }
        },
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

  Widget passwordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.lock_outline),
        ),
        obscureText: !showPassword,
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

  Widget loginButton() {
    return ElevatedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xff141E27),
          minimumSize: Size(MediaQuery.of(context).size.width * .94,
              MediaQuery.of(context).size.height * .06),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          'Login',
          style: GoogleFonts.ubuntu(
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        onPressed: () async {
          setState(() {
            isLoading = true ;
          });
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());
            if(regEmailStu.hasMatch(emailController.text.trim())){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationDrawer(),
                ),
              );
            }else if(regEmailEmp.hasMatch(emailController.text.trim())){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationDrawer(),
                ),
              );
            }
          } on FirebaseAuthException {
            Utils.showSnackBar('Wrong Email or Password!');
          }
          setState(() {
            isLoading = false ;
          });
        }
        );
  }

  Widget registerButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * .94,
            MediaQuery.of(context).size.height * .06),
        side: const BorderSide(width: 1, color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterPage(),
          ),
        );
      },
      child: Text(
        'Sign Up',
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

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

}
