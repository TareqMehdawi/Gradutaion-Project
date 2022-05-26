import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/widgets/user_class.dart';
import 'package:image_picker/image_picker.dart';

import '../pages/your_account.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({Key? key}) : super(key: key);

  @override
  EditImagePageState createState() => EditImagePageState();
}

class EditImagePageState extends State<EditImagePage> {
  var user = UserData.myUser;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String userName = '';
  String url = '';
  var pickedImage;
  bool isLoading = false;

  Widget isNull(String data) {
    if (pickedImage == null) {
      return Image.network(data);
    } else {
      return Image.file(File(user.image), width: 300, height: 300);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          leading: const BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xFFFFFFFF),
        body: FutureBuilder<Users?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something ${snapshot.error}');
            } else if (snapshot.hasData) {
              final userImage = snapshot.data;
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                          width: 330,
                          child: Text(
                            "Upload a photo of yourself:",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: 330,
                          height: 330,
                          child: GestureDetector(
                            onTap: () async {
                              buildBottomSheet();
                            },
                            child: isNull(userImage!.image),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            editButton(
                              name: 'Choose a Photo',
                              style: 2,
                              function: () async {
                                buildBottomSheet();
                              },
                            ),
                            editButton(
                              name: 'Update',
                              style: 1,
                              function: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  final ref = FirebaseStorage.instance
                                      .ref()
                                      .child('userImage')
                                      .child('${userImage.name}.jpg');
                                  await ref.putFile(pickedImage);
                                  url = await ref.getDownloadURL();
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.uid)
                                      .update({
                                    'imageUrl': url,
                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                  AwesomeDialog(
                                      autoDismiss: false,
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      animType: AnimType.BOTTOMSLIDE,
                                      title: 'Success',
                                      desc: 'Image uploaded successfully',
                                      btnOkText: "Ok",
                                      btnOkOnPress: () {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      },
                                      onDissmissCallback: (d) {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      }).show();
                                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StudentAccount()));
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Error',
                                    desc: 'Please choose a photo first',
                                    btnOkText: "Go Back",
                                    btnOkColor: Colors.red,
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              },
                            ),
                            isLoading == true
                                ? Center(
                                    child: Container(
                                        height: 150,
                                        child: Image.asset(
                                            'assets/images/loading.gif')))
                                : Text(''),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              /////////////////////////////
              return Center(
                child: Image.asset('assets/images/loading.gif'),
              );
            } else {
              /////////////////////////////
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            }
          },
        ));
  }

  Widget editButton(
      {required VoidCallback function,
      required String name,
      required int style}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 330,
        height: 50,
        child: ElevatedButton(
          onPressed: function,
          style: style == 1
              ? ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  elevation: MaterialStateProperty.all<double>(5),
                )
              : ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  elevation: MaterialStateProperty.all<double>(5),
                ),
          child: Text(
            name,
            style: style == 1
                ? const TextStyle(fontSize: 15)
                : const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
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

  Future buildBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
          child: ListView(
            children: [
              const Center(
                child: Text(
                  "Choose one of the following:",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  loginButton(
                    title: 'Camera',
                    function: () async {
                      Navigator.pop(context);
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.camera);

                      if (image == null) return;
                      setState(() {
                        pickedImage = File(image.path);
                        user = user.copy(imagePath: image.path);
                      });
                    },
                  ),
                  loginButton(
                    title: 'Gallery',
                    function: () async {
                      Navigator.pop(context);
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (image == null) return;
                      setState(() {
                        pickedImage = File(image.path);
                        user = user.copy(imagePath: image.path);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton({required String title, required VoidCallback function}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * .35,
            MediaQuery.of(context).size.height * .06),
        side: const BorderSide(width: 1, color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: function,
      child: Text(
        title,
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
