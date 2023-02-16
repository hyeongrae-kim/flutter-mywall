import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/user/model/wall_element_model.dart';

final wallElementListProvider =
    StateNotifierProvider<WallElementListNotifier, List<WallElement>>(
        (ref) => WallElementListNotifier());

class WallElementListNotifier extends StateNotifier<List<WallElement>> {
  WallElementListNotifier() : super([]);

  // state 요소 추가
  append(WallElement e) {
    e = e.copyWith(id: state.length + 1);
    state = [...state, e];
  }

  // state 요소 삭제
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

  bool getShowEditButtons(int id){
    for(final s in state){
      if(s.id==id){
        return s.showEditButtons!;
      }
    }
    return false;
  }

  offAllShowEditButtons(){
    state = state.map((e) => e.copyWith(showEditButtons: false)).toList();
  }

  // state 요소 width 값 수정
  setWidth(int id, double width) {
    state = state
        .map((e) =>
            e.id == id ? e.copyWith(elementWidth: e.elementWidth! + width) : e)
        .toList();
  }

  updatePosition(int id, Offset updatePosition) {
    state = [
      for (final s in state)
        if (s.id==id)
          s.copyWith(elementPosition: updatePosition)
        else
          s,
    ];
  }

  changeShowEditButtons(int id) {
    for (final e in state) {
      if (e.id != id) {
        e.showEditButtons = false;
      } else {
        e.showEditButtons = true;
      }
    }
  }

  changePriority(int id) {
    WallElement? tmp;
    for (final e in state) {
      if (e.id == id) {
        tmp = e.copyWith();
        break;
      }
    }
    if (tmp == null) {
      print('id error');
      return;
    }
    state = [
      for (final e in state)
        if (e.id != id) e.copyWith(showEditButtons: false),
      tmp,
    ];
  }
}
