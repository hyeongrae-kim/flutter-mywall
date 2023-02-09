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
      elementWidth: e.elementWidth,
      id: state.length + 1,
    );
    state = [...state, e];
  }

  delete(int id) {
    state = [
      for (final e in state)
        if (e.id != id) e
    ];
  }

  double getWidth(int id) {
    for (final e in state) {
      if (e.id == id && e.elementWidth != null) {
        return e.elementWidth!;
      }
    }
    print('id or element width error!');
    return 0;
  }

  setWidth(int id, double width) {
    state = state
        .map((e) => e.id != id
            ? e
            : e = WallElement(
                rawImg: e.rawImg,
                elementWidth: e.elementWidth!+width,
                elementPosition: e.elementPosition,
                id: e.id,
              ))
        .toList();
  }

  updatePosition(int id, Offset updatePosition) {
    state = state
        .map((e) => e.id != id
            ? e
            : e = WallElement(
                rawImg: e.rawImg,
                elementWidth: e.elementWidth,
                elementPosition: updatePosition,
                id: e.id,
              ))
        .toList();
    if (state[state.length - 1].id != id ||
        state[state.length - 1].showEditButtons == false) {
      changePriority(id);
    }
  }

  changeShowEditButtons(int id) {
    for (final e in state) {
      if (e.id != id) {
        e.showEditButtons = false;
      }
    }
  }

  changePriority(int id) {
    WallElement? tmp;
    for (final e in state) {
      if (e.id == id) {
        e.showEditButtons = true;
        tmp = e;
      } else {
        e.showEditButtons = false;
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
