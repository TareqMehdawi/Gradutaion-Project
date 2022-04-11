import 'package:flutter/material.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';

class YourAccount extends StatelessWidget {
  const YourAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Account'
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xff141E27),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: const Color(0xff141E27),
                height: 280,
              ),
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(image),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 20,
                ),
                Text('Name: Tareq Mehdawi' , style: TextStyle(fontSize: 24),),
                SizedBox(
                  height: 20,
                ),
                Text('Email: Tareq@gmail.com' , style: TextStyle(fontSize: 24),),
                SizedBox(
                  height: 20,
                ),
                Text('Office: 302 ' , style: TextStyle(fontSize: 24),),
                SizedBox(
                  height: 20,
                ),
                Text('Working Hours: 08:00 am - 03:00 pm' , style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
