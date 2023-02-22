import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/user/provider/wall_provider.dart';

class AssetImageElement extends ConsumerWidget {
  final int id;
  final String assetUrl;

  const AssetImageElement({
    required this.id,
    required this.assetUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Image.asset(
      assetUrl,
      width: ref.read(wallElementListProvider.notifier).getWidth(id),
    );
  }
}
