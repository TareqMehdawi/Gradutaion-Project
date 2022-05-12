import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/test.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool lockApp = true;
  bool fingerPrint = true;
  bool notifications = true;
  final user = FirebaseAuth.instance.currentUser!;
  String userName = '';
  String userPhone = '';

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: const Color(0xff141E27),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          settingsTitle(title: 'Common'),
          settingsTiles(
              icon: Icons.language, title: 'Language', subtitle: 'English'),
          settingsTitle(title: 'Account'),
          settingsTiles(
              icon: Icons.phone, title: 'Phone number', subtitle: userPhone),
          settingsTiles(
              icon: Icons.email,
              title: 'Username',
              subtitle: userName),
          settingsTilesNoSubtitle(icon: Icons.logout, title: 'Sign out'),
          settingsTitle(title: 'Security'),
          lockAppTile(
              icon: Icons.phonelink_lock_rounded,
              title: 'Lock app in background'),
          useFingerPrintsTile(
              icon: Icons.fingerprint, title: 'Use fingerprint'),
          settingsTilesNoSubtitle(icon: Icons.lock, title: 'Change password'),
          enableNotificationsTile(
              icon: Icons.notifications_active, title: 'Enable notifications'),
        ],
      ),
    );
  }

  Widget settingsTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }

  Widget settingsTiles(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {},
    );
  }

  Widget settingsTilesNoSubtitle(
      {required IconData icon, required String title}) {
    return ListTile(
        tileColor: Colors.white,
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Tareq()));
        });
  }

  Widget lockAppTile({required IconData icon, required String title}) {
    return ListTile(
        tileColor: Colors.white,
        leading: Icon(icon),
        title: Text(title),
        trailing: Switch(
          value: lockApp,
          activeColor: const Color(0xff141E27),
          onChanged: (bool value) {
            setState(() {
              lockApp = value;
            });
          },
        ),
        onTap: () {
          setState(() {
            lockApp = !lockApp;
          });
        });
  }

  Widget useFingerPrintsTile({required IconData icon, required String title}) {
    return ListTile(
        tileColor: Colors.white,
        leading: Icon(icon),
        title: Text(title),
        trailing: Switch(
          value: fingerPrint,
          activeColor: const Color(0xff141E27),
          onChanged: (bool value) {
            setState(() {
              fingerPrint = value;
            });
          },
        ),
        onTap: () {
          setState(() {
            fingerPrint = !fingerPrint;
          });
        });
  }

  Widget enableNotificationsTile(
      {required IconData icon, required String title}) {
    return ListTile(
        tileColor: Colors.white,
        leading: Icon(icon),
        title: Text(title),
        trailing: Switch(
          value: notifications,
          activeColor: const Color(0xff141E27),
          onChanged: (bool value) {
            setState(() {
              notifications = value;
            });
          },
        ),
        onTap: () {
          setState(() {
            notifications = !notifications;
          });
        });
  }
  getData() async {
    //users???
    var name = FirebaseFirestore.instance.collection("employee").doc(user.uid);
    await name.get().then((value) {
      setState(() {
        userName = value.data()!['name'].toString();
      });
    });
    //users???
    var phone = FirebaseFirestore.instance.collection("employee").doc(user.uid);
    await phone.get().then((value) {
      setState(() {
        userPhone = value.data()!['phoneNumber'].toString();
      });
    });
  }
}
