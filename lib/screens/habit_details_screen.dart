import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habits/components/badge.dart';
import 'package:habits/components/badge_card.dart';
import 'package:habits/components/custom_appbar.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habits/components/edit_habit_card.dart';
import 'package:habits/components/habit_details_card.dart';
import 'package:habits/components/reminder_chips.dart';
import 'package:habits/components/weekday_select.dart';
import 'package:habits/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekday_selector/weekday_selector.dart';

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
  // var dataset = {
  //   DateTime(2023, 1, 6): 1,
  //   DateTime(2023, 1, 7): 1,
  //   DateTime(2023, 1, 8): 1,
  //   DateTime(2023, 1, 9): 1,
  //   DateTime(2023, 1, 13): 1,
  // };

  List<bool?> getWeekdaysBool(List weekdays) {
    List<bool?> res = [];

    if (weekdays.contains('sunday')) {
      res.add(true);
    } else {
      res.add(false);
    }
    if (weekdays.contains('monday')) {
      res.add(true);
    } else {
      res.add(false);
    }
    if (weekdays.contains('tuesday')) {
      res.add(true);
    } else {
      res.add(false);
    }
    if (weekdays.contains('wednesday')) {
      res.add(true);
    } else {
      res.add(false);
    }
    if (weekdays.contains('thursday')) {
      res.add(true);
    } else {
      res.add(false);
    }
    if (weekdays.contains('friday')) {
      res.add(true);
    } else {
      res.add(false);
    }
    if (weekdays.contains('saturday')) {
      res.add(true);
    } else {
      res.add(false);
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
                      // S
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
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                  text: 'You have maintained your habit for '),
                              TextSpan(
                                text: '83.3% ',
                                style: TextStyle(color: kPrimaryColour),
                              ),
                              TextSpan(text: 'of the total days'),
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
                // SliverGrid(
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2),
                //   delegate: SliverChildListDelegate(
                //     [
                //       const HabitBadge(
                //         title: 'New Beginnings',
                //         subtitle: 'Start a new habit',
                //         badgeIconData: Icons.local_fire_department,
                //         badgeIconColor: Colors.yellow,
                //       ),
                //       const HabitBadge(
                //         title: 'New Beginnings',
                //         subtitle: 'Start a new habit',
                //         badgeIconData: Icons.local_fire_department,
                //         badgeIconColor: Colors.yellow,
                //       ),
                //     ],
                //   ),
                // ),
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
                        : const HabitBadge(
                            title: 'Locked',
                            subtitle: 'Keep working to unlock!',
                            badgeIconData: Icons.lock,
                            badgeIconColor: Colors.grey,
                            ringColor: Colors.grey,
                          );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
