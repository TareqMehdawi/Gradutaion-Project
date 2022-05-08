import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserInformation{
  final user = FirebaseAuth.instance.currentUser!;

  getUserName({required String userName}) async {
    var name = FirebaseFirestore.instance.collection("users").doc(user.uid);
    await name.get().then((value) {
      userName = value.data()!['name'].toString();
    });
}
  getUserPhoneNumber({required String userPhone }) async {

    var phone = FirebaseFirestore.instance.collection("users").doc(user.uid);
    await phone.get().then((value) {
      userPhone = value.data()!['phoneNumber'].toString();
    });
  }
}
