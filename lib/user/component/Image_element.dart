import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageElement extends StatelessWidget {
  final Uint8List rawImg;

  const ImageElement({
    required this.rawImg,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      rawImg,
      width: MediaQuery.of(context).size.width/(1.5),
    );
  }
}
