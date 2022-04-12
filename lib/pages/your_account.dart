import 'package:flutter/material.dart';
import 'package:graduation_project/pages/navigation_drawer.dart';

class YourAccount extends StatelessWidget {
  const YourAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
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
                height: 220,
              ),
              InkWell(
                onTap: () {
                  //navigateSecondPage(EditImagePage());
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(image),
                  ),
                ),
              ),
              Positioned(
                  right: MediaQuery.of(context).size.height * 0.2,
                  top: 35,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),

                ListTile(
                  leading: Text(
                    "sssss",
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 40.0,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                ),
                // Container(
                //     width: 350,
                //     height: 40,
                //     decoration: const BoxDecoration(
                //         border: Border(
                //             bottom: BorderSide(color: Colors.grey, width: 1)))
                // ),

                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Email: Tareq@gmail.com',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Office: 302 ',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Working Hours: 08:00 am - 03:00 pm',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
