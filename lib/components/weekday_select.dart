import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../constants.dart';

class WeekdaySelect extends StatefulWidget {
  const WeekdaySelect({Key? key, required this.weekdays, required this.habitId})
      : super(key: key);

  final List<bool?> weekdays;
  final String habitId;

  @override
  State<WeekdaySelect> createState() => _WeekdaySelectState();
}

class _WeekdaySelectState extends State<WeekdaySelect> {
  String getWeekday(int day) {
    switch (day) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('habits')
          .doc(widget.habitId)
          .snapshots(),
      builder: (context, snapshot) {
        return WeekdaySelector(
          onChanged: (day) {
            final docRef = FirebaseFirestore.instance
                .collection('habits')
                .doc(widget.habitId);
            final index = day % 7;
            setState(() {
              widget.weekdays[index] = !widget.weekdays[index]!;
              final weekday = getWeekday(day);
              if(widget.weekdays[index]!) {
                List list = snapshot.data!['weekdays'];
                list.add(weekday);
                docRef.update({'weekdays': list});
              } else {
                List list = snapshot.data!['weekdays'];
                list.remove(weekday);
                docRef.update({'weekdays': list});
              }
            });
          },
          values: widget.weekdays,
          selectedFillColor: kPrimaryColour,
          elevation: 0,
          selectedElevation: 0,
        );
      },
    );
  }
}
