import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits/constants.dart';

class BadgeDetails {
  BadgeDetails(
      {required this.title,
      required this.subtitle,
      required this.iconData,
      required this.iconColor});

  String title;
  String subtitle;
  IconData iconData;
  Color iconColor;
}

final List<BadgeDetails> badgeDetails = [
  BadgeDetails(
    title: 'New Beginnings',
    subtitle: 'Start a new habit',
    iconData: Icons.whatshot,
    iconColor: Colors.orange,
  ),
  BadgeDetails(
    title: 'Going strong',
    subtitle: 'Complete 7 active days',
    iconData: Icons.flash_on,
    iconColor: Colors.yellow,
  ),
];
