import 'package:flutter/material.dart';
import 'package:habits/constants.dart';

class HabitBadge extends StatefulWidget {
  const HabitBadge(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.badgeIconData,
      required this.badgeIconColor})
      : super(key: key);

  final IconData badgeIconData;
  final Color badgeIconColor;
  final String title;
  final String subtitle;

  @override
  State<HabitBadge> createState() => _HabitBadgeState();
}

class _HabitBadgeState extends State<HabitBadge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColour),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Icon(
                widget.badgeIconData,
                size: 60,
                color: widget.badgeIconColor,
              ),
            ),
          ),
          Text(widget.title),
          Text(
            widget.subtitle,
            style: TextStyle(color: kGreyTextColour),
          ),
        ],
      ),
    );
  }
}
