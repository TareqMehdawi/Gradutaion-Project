import 'dart:io';
import 'your_account.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({Key? key}) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  var user = UserData.myUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    iconTheme: IconThemeData(color: Colors.black),
    leading: BackButton(),
    backgroundColor: Colors.transparent,
    elevation: 0,
    ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              width: 330,
              child: const Text(
                "Upload a photo of yourself:",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 330,
                  child: GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (image == null) return;
                      setState(
                              () => user = user.copy(imagePath: image.path)

                      );

    },
                    child: Image.file(File(user.image),width: 300,height: 300),
                  ))),
          Padding(
              padding: EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context,user.image);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}
