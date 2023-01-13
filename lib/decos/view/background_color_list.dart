import 'package:flutter/material.dart';
import 'package:mywall/common/layout/default_layout.dart';

class BackgroundColorList extends StatelessWidget {
  const BackgroundColorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Background Color',
      body: Center(
        child: Text('background color list'),
      ),
    );
  }
}
