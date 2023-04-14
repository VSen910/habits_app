import 'package:flutter/material.dart';

import '../constants.dart';

class DrawerInfoTile extends StatefulWidget {
  const DrawerInfoTile({Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  State<DrawerInfoTile> createState() => _DrawerInfoTileState();
}

class _DrawerInfoTileState extends State<DrawerInfoTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 24, color: kPrimaryColour),
          ),
        ),
      ],
    );
  }
}
