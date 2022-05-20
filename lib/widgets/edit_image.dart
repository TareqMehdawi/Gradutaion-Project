import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:graduation_project/widgets/user_class.dart';
import '../pages/your_account.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({Key? key}) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  var user = UserData.myUser;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String userName = '';
  String url = '';
  var pickedImage;

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
            body: FutureBuilder<Users?>(
                future: readUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final userImage = snapshot.data;
                    return Center(
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
                                  final image = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);

                                  if (image == null) return;

                                  setState(() {
                                    pickedImage = File(image.path);
                                    user = user.copy(imagePath: image.path);
                                  });
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
                                    final image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    if (image == null) return;

                                    setState(() {
                                      pickedImage = File(image.path);
                                      user = user.copy(imagePath: image.path);
                                    });
                                  },
                                ),
                                editButton(
                                  name: 'Update',
                                  style: 1,
                                  function: () async {
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
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.SUCCES,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Success',
                                        desc: 'Image uploaded successfully',
                                        btnOkText: "Ok",
                                        btnOkOnPress: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const StudentAccount(),
                                            ),
                                          );
                                        },
                                      ).show();
                                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StudentAccount()));
                                    } on FirebaseAuthException catch (e) {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Error',
                                        desc: '${e.message}',
                                        btnOkText: "Ok",
                                        btnOkOnPress: () {
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                        },
                                      ).show();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    /////////////////////////////
                    return Center(
                      child: Text('Error ${snapshot.error}'),
                    );
                  }
                },
            ),
          );
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
}
