import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/widgets/edit_office.dart';
import 'package:graduation_project/widgets/edit_office_time.dart';
import 'package:graduation_project/widgets/spinKit_widget.dart';
import '../widgets/edit_image.dart';
import '../widgets/edit_name.dart';
import '../widgets/edit_phone.dart';
import '../widgets/edit_email.dart';
import '../widgets/user_class.dart';

class EmployeeAccount extends StatefulWidget {
  const EmployeeAccount( {
    Key? key,
  }) : super(key: key);

  @override
  _YourAccount2 createState() => _YourAccount2();
//const YourAccount({Key? key}) : super(key: key);
}

class _YourAccount2 extends State<EmployeeAccount> {
  String? image;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String userName = '';
  String userPhone = '';
  String? imgUrl;
  var user = UserData.myUser;
  bool isLoading = false;

  Object isNull() {
    if (imgUrl == null) {
      return const AssetImage('assets/images/default_image.png');
    } else {
      return NetworkImage(imgUrl!);
    }
  }

  @override
  void initState() {
    readUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const SpinKitWidget()
        : Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xff141E27),
      ),
      body: FutureBuilder<UserAccount?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something ${snapshot.error}');
            } else if (snapshot.hasData) {
              final user = snapshot.data;
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: const Color(0xff141E27),
                        height: MediaQuery.of(context).size.height * .27,
                      ),
                      InkWell(
                        onTap: () async {
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const EditImagePage()));
                        },
                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 75,
                                backgroundColor:
                                const Color.fromRGBO(64, 105, 225, 1),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    user!.image,
                                  ),
                                  radius: 70,
                                ),
                              ),
                              Positioned(
                                right: 4,
                                top: 10,
                                child: ClipOval(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    color: Colors.white,
                                    child: const Icon(
                                      Icons.edit,
                                      color:
                                      Color.fromRGBO(64, 105, 225, 1),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              //title,
                              "Name",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                                width: 350,
                                height: 40,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ))),
                                child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: TextButton(
                                            child: Text(
                                              //getValue,
                                              user.name,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  height: 1.4,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              navigateSecondPage(
                                                  const EditNameFormPage());
                                            },
                                          )),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.grey,
                                        size: 40.0,
                                      )
                                    ]))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              //title,
                              "Phone",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                                width: 350,
                                height: 40,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ))),
                                child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: TextButton(
                                            child: Text(
                                              //getValue,
                                              user.number,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  height: 1.4,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              navigateSecondPage(
                                                  const EditPhoneFormPage());
                                            },
                                          )),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.grey,
                                        size: 40.0,
                                      )
                                    ]))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              //title,
                              "Email",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                                width: 350,
                                height: 40,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ))),
                                child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: TextButton(
                                            child: Text(
                                              //getValue,
                                              user.email,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  height: 1.4,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              navigateSecondPage(
                                                  const EditEmailFormPage());
                                            },
                                          )),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.grey,
                                        size: 40.0,
                                      )
                                    ]))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              //title,
                              "Office",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                                width: 350,
                                height: 40,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: TextButton(
                                            child: Text(
                                              //getValue,
                                              user.office,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  height: 1.4,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              navigateSecondPage(
                                                  const EditOfficeFormPage());
                                            },
                                          )),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.grey,
                                        size: 40.0,
                                      )
                                    ]))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        workingHoursButton(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              print(snapshot.error);
              /////////////////////////////
              return const Center(
                child: Text('Loading...'),
              );
            }
          }),
    );
  }

  Widget workingHoursButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xff141E27),
        minimumSize: Size(MediaQuery.of(context).size.width * .85,
            MediaQuery.of(context).size.height * .07),
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
            builder: (context) => const EditOfficeHoursFormPage(),
          ),
        );
      },
      child: Text(
        'Choose Working Hours',
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget imageCircle() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 75,
            backgroundColor: const Color.fromRGBO(64, 105, 225, 1),
            child: CircleAvatar(
              backgroundImage: isNull() as ImageProvider,
              radius: 70,
            ),
          ),
          Positioned(
            right: 4,
            top: 10,
            child: ClipOval(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: const Icon(
                  Icons.edit,
                  color: Color.fromRGBO(64, 105, 225, 1),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<UserAccount?> readUser() async {
    setState(() {
      isLoading = true;
    });
    final getUser =
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final snapshot = await getUser.get();
    if (snapshot.exists) {
      setState(() {
        isLoading = false;
      });
      return UserAccount.fromJson(snapshot.data()!);
    }
    return null;
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}

class User {
  String image;
  String name;
  String email;
  String phone;

  User({
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
  });

  User copy({
    String? imagePath,
    String? name,
    String? phone,
    String? email,
  }) =>
      User(
        image: imagePath ?? image,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );
}

class UserData {
  static User myUser = User(
    image: 'assets/images/default_image.png',
    name: 'Test Test',
    email: 'test.test@gmail.com',
    phone: '(208) 206-5039',
  );
}
