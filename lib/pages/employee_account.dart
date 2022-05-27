import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/widgets/edit_office.dart';
import 'package:graduation_project/widgets/edit_office_time.dart';
import 'package:graduation_project/widgets/spinKit_widget.dart';

import '../widgets/edit_email.dart';
import '../widgets/edit_image.dart';
import '../widgets/edit_name.dart';
import '../widgets/edit_phone.dart';
import '../widgets/user_class.dart';

class EmployeeAccount extends StatefulWidget {
  const EmployeeAccount({
    Key? key,
  }) : super(key: key);

  @override
  _YourAccount2 createState() => _YourAccount2();
//const YourAccount({Key? key}) : super(key: key);
}

class _YourAccount2 extends State<EmployeeAccount> {
  int kSpacingUnit = 10;

  String? image;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String userName = '';
  String userPhone = '';
  String? imgUrl;
  var user = UserData.myUser;
  bool isLoading = false;

  Object userImage() {
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
            //backgroundColor: Color(0xff205375),
            // appBar: AppBar(
            //   title: const Text('Your Account'),
            //   centerTitle: true,
            //   elevation: 0,
            //   backgroundColor: Colors.transparent,
            // ),
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
              child: FutureBuilder<UserAccount?>(
                  future: readUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final user = snapshot.data;
                      return ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                padding: EdgeInsets.all(10),
                                iconSize: 30.0,
                                icon: Icon(Icons.arrow_back),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                //color: const Color(0xff205375),
                                height:
                                    MediaQuery.of(context).size.height * .27,
                              ),
                              InkWell(
                                onTap: () async {
                                  await Navigator.push(
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
                                            const Color(0xffD8D2CB),
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
                                              color: Color.fromRGBO(
                                                  64, 105, 225, 1),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    navigateSecondPage(
                                        const EditNameFormPage());
                                  },
                                  child: Container(
                                    height: kSpacingUnit * 5.5,
                                    width:
                                        MediaQuery.of(context).size.width * 2.7,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: kSpacingUnit * 4,
                                    ).copyWith(
                                      bottom: kSpacingUnit * 1,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: kSpacingUnit * 2,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          kSpacingUnit * 3),
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
                                        Text(
                                          user.name,
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
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    navigateSecondPage(
                                        const EditPhoneFormPage());
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
                                      borderRadius: BorderRadius.circular(
                                          kSpacingUnit * 3),
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
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    navigateSecondPage(
                                        const EditEmailFormPage());
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
                                      borderRadius: BorderRadius.circular(
                                          kSpacingUnit * 3),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.email,
                                          color: Color(0xff205375),
                                          size: kSpacingUnit * 2.5,
                                        ),
                                        SizedBox(width: kSpacingUnit * 1.5),
                                        Text(
                                          user.email,
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
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    navigateSecondPage(
                                        const EditOfficeFormPage());
                                  },
                                  child: Container(
                                    height: kSpacingUnit * 5.5,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: kSpacingUnit * 4,
                                    ).copyWith(
                                      bottom: kSpacingUnit * 2,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: kSpacingUnit * 2,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          kSpacingUnit * 3),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          color: Color(0xff205375),
                                          size: kSpacingUnit * 2.5,
                                        ),
                                        SizedBox(width: kSpacingUnit * 1.5),
                                        Text(
                                          user.office,
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
                                workingHoursButton(),
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
            ),
          );
  }

  Widget workingHoursButton() {
    return Center(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xffF0F2F8), //F0F2F8
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
                fontSize: 20,
                color: Color(0xff205375),
                fontWeight: FontWeight.w500),
          ),
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
              backgroundImage: userImage() as ImageProvider,
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
// class InfoCard extends StatelessWidget {
//   // the values we need
//   final String text;
//   final IconData icon;
//   Function onPressed;
//
//   InfoCard(
//       {@required this.text, @required this.icon, @required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Card(
//         color: Colors.white,
//         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//         child: ListTile(
//           leading: Icon(
//             icon,
//             color: Colors.teal,
//           ),
//           title: Text(
//             text,
//             style: TextStyle(
//                 color: Colors.teal,
//                 fontSize: 20,
//                 fontFamily: "Source Sans Pro"),
//           ),
//         ),
//       ),
//     );
//   }
// }
