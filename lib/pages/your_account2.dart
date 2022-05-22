import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/user_class.dart';
import 'appointment.dart';
class YourAccount2 extends StatefulWidget {
  final String uid;
  final String stdName;
  const YourAccount2({  Key? key,  required this.uid,  required this.stdName}) : super(key: key);

  @override
  _YourAccount2 createState() => _YourAccount2();
//const YourAccount({Key? key}) : super(key: key);
}

class _YourAccount2 extends State<YourAccount2> {
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

  String officeDays( Map<dynamic, dynamic> map){
   String office ="";

    for(var m in map.keys){
   office ='$office$m : \n';
    }

    return office;
  }

  String officeHours( Map<dynamic, dynamic> map){
    String office ="";

    for(var m in map.keys){
      office ='$office${map[m]}  \n';
    }

    return office;
  }


  @override
  void initState() {
    readUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
              child: FutureBuilder<UserAccount?> (
                  future: readUser(),
                builder: (context, snapshot){
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }else if (snapshot.hasData) {
                  final user = snapshot.data! ;
                  return ListView(
                      children : [
                        Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(left: 5),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.chevron_left_sharp,
                                  color: Colors.indigo,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(user.image,),
                              //backgroundColor: Colors.lightBlue[100],
                              radius: 80,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              user.name,
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   // children: [
                            //   //   for (var i = 0; i < document['rating']; i++)
                            //   //     Icon(
                            //   //       Icons.star_rounded,
                            //   //       color: Colors.indigoAccent,
                            //   //       size: 30,
                            //   //     ),
                            //   //   if (5 - document['rating'] > 0)
                            //   //     for (var i = 0; i < 5 - document['rating']; i++)
                            //   //       Icon(
                            //   //         Icons.star_rounded,
                            //   //         color: Colors.black12,
                            //   //         size: 30,
                            //   //       ),
                            //   // ],
                            // ),
                            const SizedBox(
                              height: 14,
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Icon(Icons.place_outlined),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.4,
                                    child: Text(
                                      user.office.isEmpty?"no location":user.office,
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 12,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Icon(Icons.email),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                   user.email,
                                    style: GoogleFonts.lato(
                                        fontSize: 16, color: Colors.blue),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Icon(Icons.access_time_rounded),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: [
                                        Text(
                                          user.officeHours.isEmpty?"no office hours":officeDays(user.officeHours),
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          user.officeHours.isEmpty?"no office hours":officeHours(user.officeHours),
                                          style: GoogleFonts.lato(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  primary: Colors.indigo.withOpacity(0.9),
                                  onPrimary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingScreen(
                                          uid:widget.uid,
                                          empName: user.name,
                                          stdName: widget.stdName,
                                      ),

                                      // builder: (context) => BookingScreen(
                                      //   doctor: document['name'],
                                      // ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Book an Appointment',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      ]
                  );}else {
                    print(snapshot.error);
                    /////////////////////////////
                    return const Center(
                      child: Text('Loading...'),
                    );
                  }
                }

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
        FirebaseFirestore.instance.collection('users').doc(widget.uid);
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
    image: 'assets/images/default_image.png',
    name: 'Test Test',
    email: 'test.test@gmail.com',
    phone: '(208) 206-5039',
  );
}
