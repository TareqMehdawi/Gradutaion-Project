import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/login_page.dart';

import 'navigation_drawer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool showValidate = false;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        autovalidateMode: showValidate == true
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.zero,
                height: 170,
                color: const Color(0xff141E27),
                child: Center(
                  child: Text(
                    'Sign up',
                    style: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
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
      ),
    );
  }

  Widget usernameFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.person_outline_rounded),
        ),
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
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.email_outlined),
        ),
        validator: (value) {
          final regEmail = RegExp(r'^\w.+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
          if (value!.isEmpty) {
            return 'Enter an email';
          } else if (!regEmail.hasMatch(value)) {
            return 'Enter a valid email!';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget phoneFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.phone_outlined),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter a phone number';
          } else if (value.length < 10) {
            return 'Enter a valid phone number!';
          } else {
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
        controller: password,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.lock_outline),
        ),
        obscureText: !showPassword,
        validator: (value) {
          final regPassword = RegExp(
              "^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*");
          if (value!.isEmpty) {
            return 'Enter a password';
          } else if (!regPassword.hasMatch(value)) {
            return 'Password must have at least:\nOne upper case,\nOne lower case,\nOne digit,\nOne special character,\nMinimum eight characters,';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget confirmPasswordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: confirmPassword,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(
          labelText: 'Confirm Password',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.lock_outline),
        ),
        obscureText: !showPassword,
        validator: (value) {
          if (password.value != confirmPassword.value) {
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
        'Register',
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(fontSize: 20),
        ),
      ),
      onPressed: () {
        final isValid = formKey.currentState!.validate();
        FocusScope.of(context).unfocus();
        setState(() {
          showValidate = true;
        });
        if (isValid) {
          formKey.currentState?.save();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NavigationDrawer(),
            ),
          );
        }

      },
    );
  }
  Widget loginButton() {
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
            builder: (context) => const LoginPage(),
          ),
        );
      },
      child: Text(
        'Login',
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
