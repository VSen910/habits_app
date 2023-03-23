import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.titleText}) : super(key: key);

  final String titleText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: kPrimaryColour,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 16.0),
        child: Text(titleText),
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'Antre',
        fontSize: 40,
      ),
    );;
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kAppBarHeight);
}

