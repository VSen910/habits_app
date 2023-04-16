import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static Future signIn(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!)
          .get();
      await prefs.setString('username', userDoc.docs.first.get('name'));
      return prefs.getString('username');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: 'Wrong credentials, please check your email/password');
      }
      return null;
    }
  }

  static Future signUp(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        'habits': [],
        'rewards': [],
      });
      await prefs.setString('username', name);
      return name;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'This email is already in use');
      }
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

}