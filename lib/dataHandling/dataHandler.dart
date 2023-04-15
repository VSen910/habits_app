import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataHandler {
  static Future getUserId() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .get();
    return userDoc.docs.first.id;
  }

  static Future getUser() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .get();
  }

  static Stream fetchHabits() {
    return FirebaseFirestore.instance
        .collection('habits')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .snapshots();
  }
}
