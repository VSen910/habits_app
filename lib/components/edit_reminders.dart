import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habits/components/reminder_chips.dart';

class EditReminders extends StatefulWidget {
  const EditReminders(
      {Key? key, required this.habitId, required this.reminders})
      : super(key: key);

  final String habitId;
  final List<TimeOfDay> reminders;

  @override
  State<EditReminders> createState() => _EditRemindersState();
}

class _EditRemindersState extends State<EditReminders> {
  bool hasReminders = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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

          hasReminders = snapshot.data!['hasReminders'];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Enable reminders',
                      style: TextStyle(fontSize: 16),
                    ),
                    Switch(
                      value: hasReminders,
                      onChanged: (val) {
                        final docRef = FirebaseFirestore.instance
                            .collection('habits')
                            .doc(widget.habitId);
                        setState(() {
                          hasReminders = val;
                        });
                        docRef.update({'hasReminders': val});
                      },
                    ),
                  ],
                ),
              ),
              if (hasReminders)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ReminderChips(
                    reminders: widget.reminders,
                    isEdit: true,
                    habitId: widget.habitId,
                  ),
                ),
            ],
          );
        });
  }
}
