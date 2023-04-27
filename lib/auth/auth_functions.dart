import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  // static String _getWeekdayIndex(List<String> weekdays) {
  //   List res = [];
  //   for(int i=0; i<weekdays.length; i++) {
  //     switch (weekdays[i]) {
  //       case 'sunday':
  //         res.add(0);
  //         break;
  //       case 'monday':
  //         res.add(1);
  //         break;
  //       case 'tuesday':
  //         res.add(2);
  //         break;
  //       case 'wednesday':
  //         res.add(3);
  //         break;
  //       case 'thursday':
  //         res.add(4);
  //         break;
  //       case 'friday':
  //         res.add(5);
  //         break;
  //       case 'saturday':
  //         res.add(6);
  //         break;
  //     }
  //   }
  //
  //   return res.join(',');
  // }

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
      //
      // final habitsQuery =
      //     await FirebaseFirestore.instance.collection('habits').where('email', isEqualTo: email).get();
      // int notifId = prefs.getInt('notifId')!;
      //
      // for(var doc in habitsQuery.docs) {
      //   List<TimeOfDay> reminders = doc['reminders'];
      //   List<String> weekdays = doc['weekdays'];
      //   for (TimeOfDay time in reminders) {
      //     await AwesomeNotifications().createNotification(
      //       content: NotificationContent(
      //         id: notifId++,
      //         channelKey: 'basic_channel',
      //         groupKey: doc.id,
      //         title: doc['title'],
      //         body: doc['subtitle'],
      //         wakeUpScreen: true,
      //         category: NotificationCategory.Reminder,
      //         notificationLayout: NotificationLayout.Default,
      //       ),
      //       schedule: NotificationAndroidCrontab(
      //         crontabExpression:
      //         '${time.minute} ${time.hour} * * ${_getWeekdayIndex(weekdays)}',
      //         repeats: true,
      //         allowWhileIdle: true,
      //         timeZone: 'Asia/Kolkata',
      //       ),
      //     );
      //   }
      // }
      //
      // await prefs.setInt('notifId', notifId);
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

      // await Workmanager().cancelAll();
      // await AwesomeNotifications().cancelAllSchedules();

      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }
}
