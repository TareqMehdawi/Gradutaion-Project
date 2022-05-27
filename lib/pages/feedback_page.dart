import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/widgets/user_class.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String bug = 'Report a Bug';
  String feature = 'Request a Feature';
  String applause = 'Send Applause';
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: const Color(0xff205375),
          title: const Text('Feedback'),
          centerTitle: true,
        ),
        body: FutureBuilder<Users?>(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else if (snapshot.hasData) {
                final user = snapshot.data!;
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Hi there ',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff205375)
                                ),
                              ),
                              Icon(
                                Icons.emoji_emotions_outlined,
                                size: 40,
                                color:Color(0xff205375) ,
                              ),
                            ],
                          ),
                          const Text(
                            'We can\'t wait to get your thoughts on your app. what would you like to do',
                            style: TextStyle(color: Color(0xff205375)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    feedbackListTile(
                      icon: Icons.bug_report_outlined,
                      title: bug,
                      subtitle:
                          'Let us know so we can forward this to our bug control.',
                      cTitle: bug,
                      email: user.email,

                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    feedbackListTile(
                      icon: Icons.message_outlined,
                      title: feature,
                      subtitle:
                          'Do you have any idea that would make this our app better? We would love to know!',
                      cTitle: feature,
                      email: user.email,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    feedbackListTile(
                      icon: Icons.emoji_events_outlined,
                      title: applause,
                      subtitle:
                          'Let us know what you like about our app, maybe we can make it even better!',
                      cTitle: applause,
                      email: user.email,
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Center(
                    //   child: Image.asset('assets/images/loading.gif'),
                    // ),
                  ],
                );
              } else {
                /////////////////////////////
                return GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Center(
                    child: Text('Loading....'),
                  ),
                );
              }
            }));
  }

  ListTile feedbackListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String cTitle,
    required String email,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      onTap: () {
        buildBottomSheet(title: cTitle, email: email);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }

  Widget submitButton({required String title, required String email}) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xff205375),
        minimumSize: Size(MediaQuery.of(context).size.width * .94,
            MediaQuery.of(context).size.height * .06),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(
        'Submit',
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      onPressed: () {
        sendFeedback(
            title: title,
            name: nameController.text.trim(),
            message: messageController.text.trim(),
            email: email);
        AwesomeDialog(
            autoDismiss: false,
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Success',
            desc: 'Thank you for your feedback',
            btnOkText: "Ok",
            btnOkOnPress: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            onDissmissCallback: (d) {
              return Navigator.of(context).popUntil((route) => route.isFirst);
            }).show();
      },
    );
  }

  Future buildBottomSheet({required String title, required String email}) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: ListView(
          children: [
            bottomSheetText(text: 'Name'),
            nameFormField(),
            const SizedBox(
              height: 7,
            ),
            bottomSheetText(text: 'Description'),
            descriptionFormField(),
            const SizedBox(
              height: 25,
            ),
            submitButton(title: title, email: email),
          ],
        ),
      ),
    );
  }

  Future sendFeedback({
    required String title,
    required String name,
    required String message,
    required String email,
  }) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('feedback').doc();

      final user = SendFeedback(
          id: currentUser.uid,
          name: name,
          title: title,
          message: message,
          email: email);

      final json = user.toJson();

      await docUser.set(json);
    } on FirebaseAuthException catch (e) {
      AwesomeDialog(
          autoDismiss: false,
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error',
          desc: '${e.message}',
          btnOkText: "Ok",
          btnOkOnPress: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          onDissmissCallback: (d) {
            return Navigator.of(context).popUntil((route) => route.isFirst);
          }).show();
    }
  }

  Widget nameFormField() {
    return TextFormField(
      controller: nameController,
      decoration: const InputDecoration(
        hintText: "Your Name",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget descriptionFormField() {
    return TextFormField(
      controller: messageController,
      minLines: 5,
      maxLines: 10,
      decoration: const InputDecoration(
        hintText: 'Write your description here...',
        border: OutlineInputBorder(),
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

Widget bottomSheetText({required String text}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      text,
      style: const TextStyle(
          color: Color(0xff141E27), fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );
}
