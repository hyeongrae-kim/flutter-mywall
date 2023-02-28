import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final AppBar? renderAppBar;
  final bool? showAppBar;
  final Color? color;
  final Widget body;
  final String title;

  const DefaultLayout({
    this.renderAppBar,
    this.showAppBar,
    required this.body,
    required this.title,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color ?? Colors.white,
      appBar: renderAppBar ??
          (showAppBar == null ? renderDefaultAppBar(context) : null),
      body: body,
    );
  }

  AppBar renderDefaultAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        color: Colors.black,
        icon: Icon(Icons.arrow_back_ios_outlined),
        iconSize: 16.0,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
