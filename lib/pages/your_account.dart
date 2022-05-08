import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/edit_image.dart';
import '../widgets/edit_name.dart';
import '../widgets/edit_phone.dart';
import '../widgets/edit_email.dart';
import '../widgets/image_widget.dart';

class YourAccount extends StatefulWidget {
  const YourAccount({Key? key}) : super(key: key);

  @override
  _YourAccount2 createState() => _YourAccount2();
//const YourAccount({Key? key}) : super(key: key);
}
class _YourAccount2 extends State<YourAccount>{
  String? image;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String userName = '';
  String userPhone = '';

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    final user = UserData.myUser;
    //final user2= Provider.of<User>(context,listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xff141E27),
      ),
      body: Column(
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
                    var temp =await Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditImagePage()));
                    setState(() {
                      image = temp;
                    });
                  },
                  child: DisplayImage(
                    imagePath: image??user.image,
                    onPressed: () {},
                  ),),
            ],
          ),
          Padding(
            padding: EdgeInsets.zero,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Expanded(
                              child: TextButton(
                            child:  Text(
                              //getValue,
                              userName,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 16, height: 1.4,color: Colors.black),
                            ),
                            onPressed: () {
                              navigateSecondPage(const EditNameFormPage());
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: TextButton(
                                    child:  Text(
                                      //getValue,
                                      userPhone,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16, height: 1.4,color: Colors.black),
                                    ),
                                    onPressed: () {
                                      navigateSecondPage(const EditPhoneFormPage());
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: TextButton(
                                    child:  Text(
                                      //getValue,
                                      currentUser.email.toString(),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16, height: 1.4,color: Colors.black),
                                    ),
                                    onPressed: () {
                                      navigateSecondPage(const EditEmailFormPage());
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
                                ))),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: TextButton(
                                    child: const Text(
                                      //getValue,
                                      "marwan",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 16, height: 1.4,color: Colors.black),
                                    ),
                                    onPressed: () {
                                      //navigateSecondPage(editPage);
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



                // Text(
                //   'Email: Tareq@gmail.com',
                //   style: TextStyle(fontSize: 24),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   'Office: 302 ',
                //   style: TextStyle(fontSize: 24),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   'Working Hours: 08:00 am - 03:00 pm',
                //   style: TextStyle(fontSize: 16),
                // ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  getData() async {
    var name = FirebaseFirestore.instance.collection("users").doc(currentUser.uid);
    await name.get().then((value) {
      setState(() {
        userName = value.data()!['name'].toString();
      });
    });
    var phone = FirebaseFirestore.instance.collection("users").doc(currentUser.uid);
    await phone.get().then((value) {
      setState(() {
        userPhone = value.data()!['phoneNumber'].toString();
      });
    });
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


  // set changeImage(String Image){
  //   image =Image;
  //   notifyListeners();
  // }


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
    image:
    'assets/images/images.png',
    name: 'Test Test',
    email: 'test.test@gmail.com',
    phone: '(208) 206-5039',

  );
}
