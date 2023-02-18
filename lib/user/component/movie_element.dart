import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/user/provider/wall_provider.dart';

class MovieElement extends ConsumerWidget {
  final String movieUrl;
  final int id;

  const MovieElement({
    required this.movieUrl,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Image.network(
      movieUrl,
      width: ref.read(wallElementListProvider.notifier).getWidth(id),
    );
  }
}
