import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

class ReminderChips extends StatefulWidget {
  ReminderChips(
      {Key? key, required this.reminders, required this.isEdit, this.habitId})
      : super(key: key);

  List<TimeOfDay> reminders;
  final bool isEdit;
  String? habitId;

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
          if (widget.isEdit) {
            final docRef = FirebaseFirestore.instance
                .collection('habits')
                .doc(widget.habitId);
            docRef.update({
              'reminders': widget.reminders.map(
                (time) => DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  time.hour,
                  time.minute,
                ),
              )
            });
          }
        }
      },
      choiceItems: C2Choice.listFrom<int, String>(
        source: widget.reminders.map((time) => time.format(context)).toList(),
        value: (i, v) => i,
        label: (i, v) => v,
        tooltip: (i, v) => v,
        delete: (i, v) => () {
          final docRef = FirebaseFirestore.instance
              .collection('habits')
              .doc(widget.habitId);
          setState(() {
            if (widget.reminders.length > 1) {
              widget.reminders.removeAt(i);
              docRef.update({
                'reminders': widget.reminders.map(
                      (time) => DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    time.hour,
                    time.minute,
                  ),
                )
              });
            } else {
              Fluttertoast.showToast(msg: 'Must have at least one reminder');
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
            if (widget.isEdit) {
              final docRef = FirebaseFirestore.instance
                  .collection('habits')
                  .doc(widget.habitId);
              docRef.update({
                'reminders': widget.reminders.map(
                  (time) => DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    time.hour,
                    time.minute,
                  ),
                )
              });
            }
          }
        },
      ),
      wrapped: true,
    );
  }
}
