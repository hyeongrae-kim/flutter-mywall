import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/user/model/wall_element_model.dart';

final wallElementListProvider =
    StateNotifierProvider<WallElementListNotifier, List<WallElement>>(
        (ref) => WallElementListNotifier());

class WallElementListNotifier extends StateNotifier<List<WallElement>> {
  WallElementListNotifier() : super([]);

  append(WallElement e) {
    e = WallElement(
      rawImg: e.rawImg,
      elementPosition: e.elementPosition,
      id: state.length + 1,
      showEditButtons: e.showEditButtons,
    );
    state = [...state, e];
  }

  updatePosition(int id, Offset updatePosition) {
    state = state
        .map((e) => e.id != id
            ? e
            : e = WallElement(
                rawImg: e.rawImg,
                elementPosition: updatePosition,
                id: e.id,
                showEditButtons: e.showEditButtons,
              ))
        .toList();
  }

  touchElement(int id) {
    WallElement? tmp;
    for (final e in state) {
      if (e.id == id) {
        tmp = WallElement(
          rawImg: e.rawImg,
          elementPosition: e.elementPosition,
          id: e.id,
          showEditButtons: !e.showEditButtons,
        );
      }
    }
    if (tmp == null) {
      print('id error');
      return;
    }

    state = [
      for (final e in state)
        if (e.id != id) e,
      tmp,
    ];
  }
}
