import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final key = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController checkNewPasswordController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool showPassword = false;
  bool showValidate = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    checkNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,
        autovalidateMode: showValidate == true
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                child: Image.asset(
                  'assets/images/change password.png',
                  scale: 2.5,
                  width: 250,
                  height: 250,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 25),
              child: Text(
                'Change Password',
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            passwordFormField(
                title: 'Enter Current Password',
                controller: oldPasswordController),
            const SizedBox(
              height: 15,
            ),
            newPasswordFormField(
                title: 'Enter New Password', controller: newPasswordController),
            const SizedBox(
              height: 15,
            ),
            confirmPasswordFormField(),
            checkBoxWidget(),
            submitButton(context),
          ],
        ),
      ),
    );
  }

  Widget passwordFormField(
      {required String title, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: !showPassword,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.lock_outline),
        ),
        validator: (value) {
          final regPassword = RegExp(
              "^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[_!@#\$%^&*(),.?:{}|<>]).*");
          if (value!.isEmpty) {
            return 'Enter a password';
          } else if (!regPassword.hasMatch(value)) {
            return 'Password must have at least:\nOne upper case,\nOne lower case,\nOne digit,\nOne special character,\nMinimum eight characters,';
          }
          return null;
        },
      ),
    );
  }

  Widget newPasswordFormField(
      {required String title, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: !showPassword,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.lock_outline),
        ),
        validator: (value) {
          final regPassword = RegExp(
              "^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[_!@#\$%^&*(),.?:{}|<>]).*");
          if (value!.isEmpty) {
            return 'Enter a password';
          } else if (!regPassword.hasMatch(value)) {
            return 'Password must have at least:\nOne upper case,\nOne lower case,\nOne digit,\nOne special character,\nMinimum eight characters,';
          } else if (oldPasswordController.text.trim() == newPasswordController.text.trim()) {
            return 'New Password cannot be the same as the old password';
          }
          return null;
        },
      ),
    );
  }

  Widget confirmPasswordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: checkNewPasswordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(
          labelText: 'Confirm Password',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.lock_outline),
        ),
        obscureText: !showPassword,
        validator: (value) {
          if (newPasswordController.value != checkNewPasswordController.value) {
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

  Widget submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xff141E27),
          minimumSize: Size(200, MediaQuery.of(context).size.height * .08),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
        onPressed: () async {
          setState(() {
            showValidate = true;
          });
          final isValid = key.currentState!.validate();
          FocusScope.of(context).unfocus();
          if (isValid) {
            key.currentState?.save();
            try {
              var result = await currentUser.reauthenticateWithCredential(
                EmailAuthProvider.credential(
                    email: currentUser.email!,
                    password: oldPasswordController.text),
              );
              await result.user?.updatePassword(newPasswordController.text);
              AwesomeDialog(
                autoDismiss: false,
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Success',
                desc: 'Password changed successfully',
                btnOkText: "Ok",
                btnOkOnPress: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                  onDissmissCallback: (d){
                    return Navigator.of(context).popUntil((route) => route.isFirst);
                  }
              ).show();
            } on FirebaseAuthException catch (error) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Warning',
                desc: '${error.message}',
                btnOkText: "Ok",
                btnOkOnPress: () {},
                btnCancelOnPress: (){
                  Navigator.pop(context);
                  },
              ).show();
              // Utils.showSnackBar(error.message);
            }
          }
        },
      ),
    );
  }
}
