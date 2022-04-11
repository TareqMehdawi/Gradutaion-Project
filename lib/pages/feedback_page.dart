import 'package:flutter/material.dart';

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
            subtitle: 'Do you have any idea that would make this our app better? We would love to know!',
          ),
          const SizedBox(
            height: 10,
          ),
          feedbackListTile(
            icon: Icons.emoji_events_outlined,
            title: 'Send Applause',
            subtitle: 'Let us know what you like about our app, maybe we can make it even better!',
          ),
        ],
      ),
    );
  }

  ListTile feedbackListTile(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 20 ,horizontal: 15),
      onTap: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }
}
