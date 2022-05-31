import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/login_page.dart';
import 'package:graduation_project/pages/make_reservations.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';
import 'package:graduation_project/widgets/utils_show_snackbar.dart';
import 'package:provider/provider.dart';

// Future<void> _firemessaging(RemoteMessage message) async{
//   await Firebase.initializeApp();
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage((message) => _firemessaging(message));
  // FirebaseMessaging notification = FirebaseMessaging.instance;
  // FirebaseMessaging.onMessage.listen((message) {
  //   print('Got a message whilst in the foreground');
  //   print('Message Data: ${message.data}');
  //   if(message.notification !=null){
  //     print('Message notification ${message.notification}');
  //   }
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ReservationInfo()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreenWithDuration(),
      ),
    );
  }
}

class SplashScreenWithDuration extends StatefulWidget {
  const SplashScreenWithDuration({Key? key}) : super(key: key);

  @override
  State<SplashScreenWithDuration> createState() =>
      _SplashScreenWithDurationState();
}

class _SplashScreenWithDurationState extends State<SplashScreenWithDuration> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 160,
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff398AB9)),
            )
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreenWithDuration> createState() =>
      _SplashScreenWithDurationState();
}

class _SplashScreenState extends State<SplashScreenWithDuration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 160,
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff398AB9)),
            )
          ],
        ),
      ),
    );
  }
}
/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
                children: [
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .7,
                      color: Color(0xff141E27),
                      child: Center(
                        child: Text(
                          'Appointment',
                          style: GoogleFonts.ubuntu(
                              textStyle: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  homepageButtons(
                    context,
                    title: 'Login',
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  homepageButtons(
                    context,
                    title: 'Register',
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
        ),
        ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, h);
    path.quadraticBezierTo(w * 0.5, h - 120, w, h);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Widget homepageButtons(BuildContext context,
    {required String title, required VoidCallback function}) {
  return ElevatedButton(
    style: OutlinedButton.styleFrom(
      backgroundColor: const Color(0xff141E27),
      minimumSize: Size(MediaQuery.of(context).size.width * .90,
          MediaQuery.of(context).size.height * .08),
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400,),
      side: const BorderSide(width: 1, color: Color(0xff141E27)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    onPressed: function,
    child: Text(title),
  );
}

*/

//dart fix --apply
