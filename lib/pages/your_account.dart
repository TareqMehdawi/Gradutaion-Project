import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';
import 'package:provider/provider.dart';
import 'edit_image.dart';
import 'edit_name.dart';
import 'edit_phone.dart';
import 'edit_email.dart';
import 'image_widjet.dart';

class YourAccount extends StatefulWidget {
  @override
  _YourAccount2 createState() => _YourAccount2();
//const YourAccount({Key? key}) : super(key: key);
}
class _YourAccount2 extends State<YourAccount>{
  String? image;
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
                    var temp =await Navigator.push(context, MaterialPageRoute(builder: (context)=> EditImagePage()));
                    setState(() {
                      image = temp;
                    });
                  },
                  child: DisplayImage(
                    imagePath: image??user.image,
                    onPressed: () {},
                  )),
              // InkWell(
              //   onTap: () {
              //     //navigateSecondPage(EditImagePage());
              //   },
              //   child: SizedBox(
              //     height: 180,
              //     child: Stack(
              //       children: [
              //         CircleAvatar(
              //           radius: 75,
              //           backgroundColor: Colors.white,
              //           child: CircleAvatar(
              //             radius: 70,
              //             backgroundImage: AssetImage(image),
              //           ),
              //         ),
              //         const Positioned(
              //           bottom: 36,
              //           right: 10,
              //           child: CircleAvatar(
              //             backgroundColor: Colors.white,
              //             radius: 20,
              //             child: Icon(
              //               Icons.edit,
              //               color: Colors.black,
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
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
                              user.name,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16, height: 1.4,color: Colors.black),
                            ),
                            onPressed: () {
                              navigateSecondPage(EditNameFormPage());
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
                SizedBox(
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
                                      user.phone,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 16, height: 1.4,color: Colors.black),
                                    ),
                                    onPressed: () {
                                      navigateSecondPage(EditPhoneFormPage());
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
                SizedBox(
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
                                      user.email,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 16, height: 1.4,color: Colors.black),
                                    ),
                                    onPressed: () {
                                      navigateSecondPage(EditEmailFormPage());
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
                SizedBox(
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
                SizedBox(
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
        image: imagePath ?? this.image,
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
