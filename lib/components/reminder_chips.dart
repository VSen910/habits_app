import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

class ReminderChips extends StatefulWidget {
  ReminderChips({Key? key, required this.reminders}) : super(key: key);

  List<TimeOfDay> reminders;

  @override
  State<ReminderChips> createState() => _ReminderChipsState();
}

class _ReminderChipsState extends State<ReminderChips> {
  int tag = -1;

  @override
  Widget build(BuildContext context) {
    return ChipsChoice.single(
      value: tag,
      onChanged: (val) async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            widget.reminders[val] = picked;
          });
        }
      },
      choiceItems: C2Choice.listFrom<int, String>(
        source: widget.reminders.map((time) => time.format(context)).toList(),
        value: (i, v) => i,
        label: (i, v) => v,
        tooltip: (i, v) => v,
        delete: (i, v) => () {
          setState(() {
            if (widget.reminders.length > 1) {
              widget.reminders.removeAt(i);
            } else {
              Fluttertoast.showToast(msg: 'Must have at least one remider');
            }
          });
        },
      ),
      choiceStyle: C2ChipStyle.toned(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      trailing: IconButton(
        tooltip: 'Add Choice',
        icon: const Icon(
          Icons.add_circle_rounded,
          color: kPrimaryColour,
        ),
        iconSize: 30,
        onPressed: () async {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (picked != null) {
            setState(() {
              widget.reminders.add(picked);
            });
          }
        },
      ),
      wrapped: true,
    );
  }
}
