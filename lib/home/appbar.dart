import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget> actions;
  CustomAppBar(
      {required this.title,
      required this.backgroundColor,
      required this.actions});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // elevation: 4.0,
      title: Text(title),
      backgroundColor: backgroundColor,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
