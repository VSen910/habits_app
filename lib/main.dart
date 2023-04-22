import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habits/components/badge.dart';
import 'package:habits/screens/home_screen.dart';
import 'package:habits/screens/register_screen.dart';
import 'package:habits/screens/splash_screen.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await Firebase.initializeApp();
//     DateTime now = await NTP.now();
//     DateTime yesterday = DateTime(now.year, now.month, now.day - 1, 0, 0, 0);
//
//     final querySnapshotYesterday = await FirebaseFirestore.instance
//         .collection('habits')
//         .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!)
//         .where('weekdays',
//             arrayContains: DateFormat('EEEE').format(yesterday).toLowerCase())
//         .get();
//
//     for (var docSnapshot in querySnapshotYesterday.docs) {
//       final data = docSnapshot.data();
//       final documentReference =
//           FirebaseFirestore.instance.collection('habits').doc(docSnapshot.id);
//
//       // DateTime yesterday = now.subtract(const Duration(days: 1));
//       // DateTime newDate =
//       //     DateTime(yesterday.year, yesterday.month, yesterday.day);
//       if (data['currentStatus'] == 0) {
//         data['doneDates'].add(yesterday);
//         data['totalActiveDays'] += 1;
//         data['activeStreak'] += 1;
//         if (data['longestStreak'] < data['activeStreak']) {
//           data['longestStreak'] = data['activeStreak'];
//         }
//       } else {
//         if (!data['doneDates'].contains(Timestamp.fromDate(yesterday)) &&
//             !data['notDoneDates'].contains(Timestamp.fromDate(yesterday))) {
//           data['notDoneDates'].add(yesterday);
//           data['activeStreak'] = 0;
//         }
//       }
//
//       // Badge handling
//       if(data['totalActiveDays'] == 7) {
//         data['rewards'].add(1);
//       }
//
//       data['currentStatus'] = 1;
//       documentReference.update(data);
//     }
//
//     return Future.value(true);
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Reminders',
        channelDescription: 'Notification channel for reminders',
      ),
    ],
    debug: true,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else if (snapshot.hasData) {
            return SplashScreen(
              nextScreen: HomeScreen(
                username: prefs.getString('username')!,
                prefs: prefs,
              ),
              prefs: prefs,
            );
          } else {
            return SplashScreen(
              nextScreen: RegisterScreen(
                prefs: prefs,
              ),
              prefs: prefs,
            );
          }
        },
      ),
    ),
  );
}
