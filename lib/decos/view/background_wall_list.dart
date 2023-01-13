import 'package:flutter/material.dart';
import 'package:mywall/common/layout/default_layout.dart';

class BackgroundWallList extends StatelessWidget {
  const BackgroundWallList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Background Wall',
      body: Center(
        child: Text('BackgroundWall'),
      ),
    );
  }
}
