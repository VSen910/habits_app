import 'package:flutter/material.dart';
import 'package:habits/components/edit_dialog.dart';
import 'package:habits/constants.dart';

class EditHabitCard extends StatefulWidget {
  const EditHabitCard({Key? key,
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.iconColor, required this.habitId})
      : super(key: key);

  final IconData iconData;
  final String title;
  final String subtitle;
  final Color iconColor;
  final String habitId;

  @override
  State<EditHabitCard> createState() => _EditHabitCardState();
}

class _EditHabitCardState extends State<EditHabitCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                widget.iconData,
                color: widget.iconColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title),
                  Text(
                    widget.subtitle,
                    style: TextStyle(color: kGreyTextColour),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      EditDialog(
                        habitName: widget.title,
                        habitDesc: widget.subtitle,
                        iconColor: widget.iconColor,
                        iconData: widget.iconData,
                        habitId: widget.habitId,
                      ),
                );
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
