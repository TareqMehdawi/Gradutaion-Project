import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xff141E27),
        title: const Text('Feedback'),
        centerTitle: true,
      ),
      body: ListView(
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
                      ),
                    ),
                    Icon(
                      Icons.emoji_emotions_outlined,
                      size: 40,
                    ),
                  ],
                ),
                const Text(
                  'We can\'t wait to get your thoughts on your app. what would you like to do',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          feedbackListTile(
            icon: Icons.bug_report_outlined,
            title: 'Report a Bug',
            subtitle: 'Let us know so we can forward this to our bug control.',
          ),
          const SizedBox(
            height: 10,
          ),
          feedbackListTile(
            icon: Icons.message_outlined,
            title: 'Request a Feature',
            subtitle:
                'Do you have any idea that would make this our app better? We would love to know!',
          ),
          const SizedBox(
            height: 10,
          ),
          feedbackListTile(
              icon: Icons.emoji_events_outlined,
              title: 'Send Applause',
              subtitle:
                  'Let us know what you like about our app, maybe we can make it even better!',
          ),
        ],
      ),
    );
  }

  ListTile feedbackListTile(
      {required IconData icon,
      required String title,
      required String subtitle,}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      onTap: (){
        buildBottomSheet();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }

  Widget loginButton() {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xff141E27),
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
        Navigator.pop(context);
      },
    );
  }

  Future buildBottomSheet(){
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 15.0, vertical: 15),
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
            loginButton(),
          ],
        ),
      ),
    );
  }
}

Widget nameFormField() {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(
      hintText: "Your Name",
      border: OutlineInputBorder(),
    ),
  );
}

Widget descriptionFormField() {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    minLines: 5,
    maxLines: 10,
    decoration: const InputDecoration(
      hintText: 'Write your description here...',
      border: OutlineInputBorder(),
    ),
  );
}
Widget bottomSheetText({required String text}){
  return Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child:  Text(
      text,
      style: const TextStyle(
          color: Color(0xff141E27),
          fontWeight: FontWeight.bold,
          fontSize: 20),
    ),
  );
}

// Widget bottomSheet (){
//   return false;
// }
