import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/change_password.dart';
import 'package:graduation_project/pages/test.dart';
import 'package:graduation_project/widgets/edit_name.dart';

import '../widgets/edit_phone.dart';
import '../widgets/user_class.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool lockApp = true;
  bool fingerPrint = true;
  bool notifications = true;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String userName = '';
  String userPhone = '';

  @override
  void initState() {
    readUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: const Color(0xff205375),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: FutureBuilder<Users?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else if (snapshot.hasData) {
              final user = snapshot.data;
              return ListView(
                children: [
                  settingsTitle(title: 'Common'),
                  settingsTiles(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    function: () {},
                  ),
                  settingsTitle(title: 'Account'),
                  settingsTiles(
                    icon: Icons.phone,
                    title: 'Phone number',
                    subtitle: user!.number,
                    function: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EditPhoneFormPage()));
                    },
                  ),
                  settingsTiles(
                    icon: Icons.email,
                    title: 'Username',
                    subtitle: user.name,
                    function: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EditNameFormPage()));
                    },
                  ),
                  settingsTilesNoSubtitle(
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Tareq()),
                        );
                      },
                      icon: Icons.logout,
                      title: 'Sign out'),
                  settingsTitle(title: 'Security'),
                  lockAppTile(
                      icon: Icons.phonelink_lock_rounded,
                      title: 'Lock app in background'),
                  useFingerPrintsTile(
                      icon: Icons.fingerprint, title: 'Use fingerprint'),
                  settingsTilesNoSubtitle(
                    icon: Icons.lock,
                    title: 'Change password',
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangePassword()));
                    },
                  ),
                  enableNotificationsTile(
                      icon: Icons.notifications_active,
                      title: 'Enable notifications'),
                ],
              );
            } else {
              /////////////////////////////
              return const Center(
                child: Text('Loading....'),
              );
            }
          }),
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

  Widget settingsTiles({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback function,
  }) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(icon  ,color: Color(0xff205375)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: function,
    );
  }

  Widget settingsTilesNoSubtitle(
      {required IconData icon,
      required String title,
      required VoidCallback function}) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(icon,color: Color(0xff205375),),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: function,
    );
  }

  Widget lockAppTile({required IconData icon, required String title}) {
    return ListTile(
        tileColor: Colors.white,
        leading: Icon(icon,color: Color(0xff205375)),
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
        leading: Icon(icon,color: Color(0xff205375)),
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
        leading: Icon(icon,color: Color(0xff205375)),
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
