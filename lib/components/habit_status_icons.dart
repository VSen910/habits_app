import 'package:flutter/material.dart';
class DoneIcon extends StatefulWidget {
  DoneIcon({required this.onPressed});
  final VoidCallback onPressed;
  @override
  State<DoneIcon> createState() => _DoneIconState();
}

class _DoneIconState extends State<DoneIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.green),
      child: IconButton(
           onPressed: widget.onPressed,
          icon: Icon(
            Icons.done,
            color: Colors.white,
          )),
    );
  }
}


class PendingIcon extends StatefulWidget {
  const PendingIcon({Key? key}) : super(key: key);

  @override
  State<PendingIcon> createState() => _PendingIconState();
}

class _PendingIconState extends State<PendingIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.yellow),
      child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black,
          )),
    );
    ;
  }
}

class NotDoneIcon extends StatefulWidget {
  const NotDoneIcon({Key? key}) : super(key: key);

  @override
  State<NotDoneIcon> createState() => _NotDoneIconState();
}

class _NotDoneIconState extends State<NotDoneIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.red),
      child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.close,
            color: Colors.white,
          )),
    );
    ;
  }
}
