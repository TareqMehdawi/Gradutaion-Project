import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/backbutton_widget.dart';

import '../main.dart';
import '../widgets/edit_image.dart';
import '../widgets/edit_name.dart';
import '../widgets/edit_phone.dart';
import '../widgets/user_class.dart';

class StudentAccount extends StatefulWidget {
  const StudentAccount({
    Key? key,
  }) : super(key: key);

  @override
  YourAccount2 createState() => YourAccount2();
}

class YourAccount2 extends State<StudentAccount> {
  int kSpacingUnit = 10;
  String? image;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String userName = '';
  String userPhone = '';
  String? imgUrl;

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xff205375),
            Color(0xff92B4EC),
          ],
        )),
        child: FutureBuilder<Users?>(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something ${snapshot.error}');
              } else if (snapshot.hasData) {
                final user = snapshot.data;
                return ListView(children: [
                  customBackButton(color: Colors.white),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        //color: const Color(0xff205375),
                        height: MediaQuery.of(context).size.height * .27,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditImagePage()));
                        },
                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 75,
                                backgroundColor: const Color(0xffD8D2CB),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
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
                                      color: Color.fromRGBO(64, 105, 225, 1),
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
                          GestureDetector(
                            onTap: () {
                              navigateSecondPage(const EditNameFormPage());
                            },
                            child: Container(
                              height: kSpacingUnit * 5.5,
                              width: MediaQuery.of(context).size.width * 2.7,
                              margin: EdgeInsets.symmetric(
                                horizontal: kSpacingUnit * 4,
                              ).copyWith(
                                bottom: kSpacingUnit * 1,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: kSpacingUnit * 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kSpacingUnit * 3),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    color: Color(0xff205375),
                                    size: kSpacingUnit * 2.5,
                                  ),
                                  SizedBox(width: kSpacingUnit * 1.5),
                                  Container(
                                    child: FittedBox(
                                      fit :BoxFit.scaleDown,
                                      alignment : Alignment.center,
                                      child: Text(
                                        user.name,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    width: 130,

                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: kSpacingUnit * 2.5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateSecondPage(const EditPhoneFormPage());
                            },
                            child: Container(
                              height: kSpacingUnit * 5.5,
                              margin: EdgeInsets.symmetric(
                                horizontal: kSpacingUnit * 4,
                              ).copyWith(
                                bottom: kSpacingUnit * 1,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: kSpacingUnit * 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kSpacingUnit * 3),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.phone,
                                    color: Color(0xff205375),
                                    size: kSpacingUnit * 2.5,
                                  ),
                                  SizedBox(width: kSpacingUnit * 1.5),
                                  Text(
                                    user.number,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: kSpacingUnit * 2.5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                ]);
              } else {
                return splashScreen();
              }
            }),
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

  Future<Users?> readUser() async {
    final getUser =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final snapshot = await getUser.get();
    if (snapshot.exists) {
      return Users.fromJson(snapshot.data()!);
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
