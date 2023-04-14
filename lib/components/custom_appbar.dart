import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key, required this.titleText, required this.hasLeading})
      : super(key: key);

  final String titleText;
  final bool hasLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 150,
      backgroundColor: kPrimaryColour,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      title: !hasLeading ? Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 16.0),
        child: Text(titleText),
      ) : Text(titleText),
      titleTextStyle: TextStyle(
        fontFamily: 'Antre',
        fontSize: 40,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kAppBarHeight);
}
