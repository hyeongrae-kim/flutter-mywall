import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final AppBar? renderAppBar;
  final Widget body;
  final String title;

  const DefaultLayout({
    this.renderAppBar,
    required this.body,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar ?? renderDefaultAppBar(context),
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
