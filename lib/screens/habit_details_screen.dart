// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habits/components/badge.dart';
import 'package:habits/components/badge_card.dart';
import 'package:habits/components/custom_appbar.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habits/components/edit_habit_card.dart';
import 'package:habits/components/edit_reminders.dart';
import 'package:habits/components/habit_details_card.dart';
import 'package:habits/components/weekday_select.dart';
import 'package:habits/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitDetailsScreen extends StatefulWidget {
  const HabitDetailsScreen(
      {Key? key,
      required this.prefs,
      required this.username,
      required this.habitId})
      : super(key: key);

  final SharedPreferences prefs;
  final String username;
  final String habitId;

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  bool hasReminders = true;

  List<bool?> getWeekdaysBool(List weekdays) {
    List days = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday'
    ];
    List<bool?> res = [];

    for (int i = 0; i < days.length; i++) {
      if (weekdays.contains(days[i])) {
        res.add(true);
      } else {
        res.add(false);
      }
    }

    return res;
  }

  List<TimeOfDay> getReminders(List reminders) {
    List<TimeOfDay> res = [];
    for (int i = 0; i < reminders.length; i++) {
      DateTime dateTime = reminders[i].toDate();
      res.add(TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "${widget.username}'s\nhabits",
        hasLeading: true,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('habits')
              .doc(widget.habitId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final docRef = FirebaseFirestore.instance
                .collection('habits')
                .doc(snapshot.data!.id);

            final List doneDates = snapshot.data!['doneDates'];
            final List notDoneDates = snapshot.data!['notDoneDates'];

            Map<DateTime, int> dataset = {};
            for (int i = 0; i < doneDates.length; i++) {
              DateTime date = doneDates[i].toDate();
              DateTime newDate = DateTime(date.year, date.month, date.day);
              dataset[newDate] = 1;
            }
            for (int i = 0; i < notDoneDates.length; i++) {
              DateTime date = notDoneDates[i].toDate();
              DateTime newDate = DateTime(date.year, date.month, date.day);
              dataset[newDate] = 2;
            }

            final String activeStreak =
                snapshot.data!['activeStreak'].toString();
            final String longestStreak =
                snapshot.data!['longestStreak'].toString();
            final String activeDays =
                snapshot.data!['totalActiveDays'].toString();

            final weekdays = snapshot.data!['weekdays'];
            final weekdaysBool = getWeekdaysBool(weekdays);

            List<TimeOfDay> reminders =
                getReminders(snapshot.data!['reminders']);
            if (reminders.isEmpty) hasReminders = false;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 24.0,
                        ),
                        child: EditHabitCard(
                          iconData: IconData(
                              int.parse(
                                snapshot.data!['icondata'],
                                radix: 16,
                              ),
                              fontFamily: 'MaterialIcons'),
                          iconColor:
                              Color(int.parse(snapshot.data!['iconColor'])),
                          title: snapshot.data!['title'],
                          subtitle: snapshot.data!['subtitle'],
                          habitId: widget.habitId,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: WeekdaySelect(
                          weekdays: weekdaysBool,
                          habitId: widget.habitId,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: EditReminders(
                          habitId: widget.habitId,
                          reminders: reminders,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: HeatMapCalendar(
                          defaultColor: Colors.grey.shade300,
                          flexible: true,
                          colorMode: ColorMode.color,
                          datasets: dataset,
                          colorsets: const {
                            1: Colors.green,
                            2: Colors.red,
                          },
                          textColor: Colors.white,
                          monthFontSize: 24,
                          borderRadius: 10,
                          margin: const EdgeInsets.all(4),
                          showColorTip: false,
                          onClick: (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value.toString())));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HabitDetailsCard(
                          boldText: 'Active',
                          secondText: 'streak',
                          data: activeStreak,
                          textOnLeft: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HabitDetailsCard(
                          boldText: 'Longest',
                          secondText: 'streak',
                          data: longestStreak,
                          textOnLeft: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HabitDetailsCard(
                          boldText: 'Active',
                          secondText: 'days',
                          data: activeDays,
                          textOnLeft: true,
                        ),
                      ),
                      if(snapshot.data!['totalDays'] != 0)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(
                                  text: 'You have maintained your habit for '),
                              TextSpan(
                                text: '${
                                  ((snapshot.data!['totalActiveDays'] /
                                          snapshot.data!['totalDays']) *
                                      100).toStringAsFixed(2)
                                }% ',
                                style: const TextStyle(color: kPrimaryColour),
                              ),
                              const TextSpan(text: 'of the total days'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Badges',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: badgeDetails.length,
                  itemBuilder: (context, index) {
                    bool hasBadge = snapshot.data!['rewards'].contains(index);

                    return hasBadge
                        ? HabitBadge(
                            title: badgeDetails[index].title,
                            subtitle: badgeDetails[index].subtitle,
                            badgeIconData: badgeDetails[index].iconData,
                            badgeIconColor: badgeDetails[index].iconColor,
                            ringColor: kPrimaryColour,
                          )
                        : HabitBadge(
                            title: 'Locked',
                            subtitle: badgeDetails[index].subtitle,
                            badgeIconData: Icons.lock,
                            badgeIconColor: Colors.grey,
                            ringColor: Colors.grey,
                          );
                  },
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete habit'),
                                  content: const Text(
                                      'Are you sure you want to delete this habit?'
                                      '\n\n'
                                      'You will permanently lose all your progress'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        // await AwesomeNotifications().cancelNotificationsByGroupKey(docRef.id);
                                        await docRef.delete();
                                        Fluttertoast.showToast(
                                            msg: 'Habit deleted successfully');
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Delete habit',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
