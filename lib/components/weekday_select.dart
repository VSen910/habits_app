import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../constants.dart';

class WeekdaySelect extends StatefulWidget {
  const WeekdaySelect({Key? key, required this.weekdays}) : super(key: key);

  final List<bool?> weekdays;

  @override
  State<WeekdaySelect> createState() => _WeekdaySelectState();
}

class _WeekdaySelectState extends State<WeekdaySelect> {
  @override
  Widget build(BuildContext context) {
    return WeekdaySelector(
      onChanged: (day) {
        final index = day % 7;
        setState(() {
          widget.weekdays[index] = !widget.weekdays[index]!;
        });
      },
      values: widget.weekdays,
      selectedFillColor: kPrimaryColour,
      elevation: 0,
      selectedElevation: 0,
    );
  }
}
