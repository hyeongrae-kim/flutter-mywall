import 'package:flutter/material.dart';
import 'package:mywall/user/view/home_screen.dart';

void main() {
  runApp(
    _MyWall(),
  );
}

class _MyWall extends StatelessWidget {
  const _MyWall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
