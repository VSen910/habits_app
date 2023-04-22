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
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
