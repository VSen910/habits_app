import 'package:flutter/material.dart';
import 'package:habits/constants.dart';

class HabitDetailsCard extends StatefulWidget {
  const HabitDetailsCard(
      {Key? key,
      required this.boldText,
      required this.secondText,
      required this.data,
      required this.textOnLeft})
      : super(key: key);

  final String boldText;
  final String secondText;
  final String data;
  final bool textOnLeft;

  @override
  State<HabitDetailsCard> createState() => _HabitDetailsCardState();
}

class _HabitDetailsCardState extends State<HabitDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(widget.textOnLeft)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.boldText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    widget.secondText,
                    style: const TextStyle(
                      color: kGreyTextColour,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              Text(
                widget.data,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 80,
                  color: kPrimaryColour,
                ),
              ),
              if(!widget.textOnLeft)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.boldText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    widget.secondText,
                    style: const TextStyle(
                      color: kGreyTextColour,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
