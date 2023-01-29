import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/user/model/wall_element_model.dart';

final wallElementListProvider =
    StateNotifierProvider<WallElementListNotifier, List<WallElement>>(
        (ref) => WallElementListNotifier());

class WallElementListNotifier extends StateNotifier<List<WallElement>> {
  WallElementListNotifier() : super([]);

  append(WallElement e){
    state = [...state, e];
  }
}
