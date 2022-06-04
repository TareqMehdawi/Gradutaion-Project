import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/homepage.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';
import 'package:graduation_project/widgets/local_notification_service.dart';
import 'package:graduation_project/widgets/utils_show_snackbar.dart';
import 'package:provider/provider.dart';

//key =AAAAc7t946A:APA91bFfNHbG4zCoFxqgR8-i3UnX0E1SkSGJZ_iW5k6YSI-uIGpVYMqP4lgw9j45xVDXX1KnGDvW9gSejPu-tHdQFP_I11FlH_qYTrs24X3sBR7pLcbUGwPt8Qres-IoFHWCw8VuFwjw

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          context, MaterialPageRoute(builder: (context) => const HomePage()));
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
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff205375)),
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

Widget splashScreen() {
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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff205375)),
            //Color(0xff398AB9)
          )
        ],
      ),
    ),
  );
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
