import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

class ReminderChips extends StatefulWidget {
  const ReminderChips({Key? key}) : super(key: key);

  @override
  State<ReminderChips> createState() => _ReminderChipsState();
}

class _ReminderChipsState extends State<ReminderChips> {
  List<String> options = [
    'News',
    'Entertainment',
    'Politics',
    'Automotive',
    'Sports',
    'Education',
    'Fashion',
    'Travel',
    'Food',
    'Tech',
    'Science',
  ];

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
      },
      choiceItems: C2Choice.listFrom<int, String>(
        source: options,
        value: (i, v) => i,
        label: (i, v) => v,
        tooltip: (i, v) => v,
        delete: (i, v) => () {
          setState(() => options.removeAt(i));
        },
      ),
      choiceStyle: C2ChipStyle.toned(
        borderRadius: const BorderRadius. all(
          Radius.circular(5),
        ),
      ),
      trailing: IconButton(
        tooltip: 'Add Choice',
        icon: const Icon(Icons.add_box_rounded),
        onPressed: () => setState(
              () => options.add('Opt #${options.length + 1}'),
        ),
      ),
      wrapped: true,
    );
  }
}
