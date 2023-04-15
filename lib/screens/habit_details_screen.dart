import 'package:flutter/material.dart';
import 'package:habits/components/badge.dart';
import 'package:habits/components/custom_appbar.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habits/components/habit_details_card.dart';
import 'package:habits/constants.dart';

class HabitDetailsScreen extends StatefulWidget {
  const HabitDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  var dataset = {
    DateTime(2023, 1, 6): 1,
    DateTime(2023, 1, 7): 1,
    DateTime(2023, 1, 8): 1,
    DateTime(2023, 1, 9): 1,
    DateTime(2023, 1, 13): 1,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Sleep early',
        hasLeading: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: HeatMapCalendar(
                      defaultColor: Colors.grey.shade300,
                      flexible: true,
                      colorMode: ColorMode.color,
                      datasets: dataset,
                      colorsets: const {
                        1: Colors.green,
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HabitDetailsCard(
                      boldText: 'Active',
                      secondText: 'streak',
                      data: '8',
                      textOnLeft: true,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HabitDetailsCard(
                      boldText: 'Longest',
                      secondText: 'streak',
                      data: '11',
                      textOnLeft: false,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HabitDetailsCard(
                      boldText: 'Active',
                      secondText: 'days',
                      data: '20',
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
                          TextSpan(text: 'You have maintained your habit for '),
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
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              delegate: SliverChildListDelegate(
                [
                  const HabitBadge(
                    title: 'New Beginnings',
                    subtitle: 'Start a new habit',
                    badgeIconData: Icons.local_fire_department,
                    badgeIconColor: Colors.yellow,
                  ),
                  const HabitBadge(
                    title: 'New Beginnings',
                    subtitle: 'Start a new habit',
                    badgeIconData: Icons.local_fire_department,
                    badgeIconColor: Colors.yellow,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
