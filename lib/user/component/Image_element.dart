import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/user/model/wall_element_model.dart';
import 'package:mywall/user/provider/wall_provider.dart';

class ImageElement extends ConsumerWidget {
  final Uint8List rawImg;
  final int id;

  const ImageElement({
    required this.rawImg,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Image.memory(
      rawImg,
      width: ref.read(wallElementListProvider.notifier).getWidth(id),
    );
  }
}
