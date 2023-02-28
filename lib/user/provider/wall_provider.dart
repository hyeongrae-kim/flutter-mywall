import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/user/model/wall_element_model.dart';
import 'package:mywall/user/model/wall_status_model.dart';

final wallStatusProvider =
    StateNotifierProvider<WallStatusNotifier, WallStatus>(
        (ref) => WallStatusNotifier());

class WallStatusNotifier extends StateNotifier<WallStatus> {
  WallStatusNotifier() : super(WallStatus(color: Colors.white));

  changeColor(Color color) {
    state = state.copyWith(color: color, assetUrl: null);
  }

  changeWallPhoto(String? assetUrl){
    state = state.copyWith(color: Colors.white, assetUrl: assetUrl);
  }
}

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

  // state 요소 순서 바꾸기
  reOrder(int id) {
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
      tmp.copyWith(showEditButtons: true),
    ];
  }

  // state 요소 삭제
  delete(int id) {
    state = [
      for (final e in state)
        if (e.id != id) e
    ];
  }

  double getAngle(int id) {
    for (final e in state) {
      if (e.id == id) {
        return e.angle;
      }
    }
    return 0.0;
  }

  double getWidth(int id) {
    for (final e in state) {
      if (e.id == id) {
        return e.elementWidth;
      }
    }
    return 0;
  }

  bool getShowEditButtons(int id) {
    for (final s in state) {
      if (s.id == id) {
        return s.showEditButtons!;
      }
    }
    return false;
  }

  // state 요소 width 값 수정
  setWidth(int id, double width) {
    state = state
        .map((e) =>
            e.id == id ? e.copyWith(elementWidth: e.elementWidth + width) : e)
        .toList();
  }

  // state요소 position 값 update
  setPosition(int id, Offset updatePosition) {
    state = [
      for (final s in state)
        if (s.id == id) s.copyWith(elementPosition: updatePosition) else s,
    ];
  }

  // state요소 anlge값 변환
  setAngle(int id, double angle) {
    state = [
      for (final s in state)
        if (s.id == id) s.copyWith(angle: angle) else s,
    ];
  }

  // state요소 baseAngle값 변환
  setBaseAngle(int id, double baseAngle) {
    state = [
      for (final s in state)
        if (s.id == id) s.copyWith(baseAngle: baseAngle) else s,
    ];
  }

  offAllShowEditButtons() {
    state = [
      for (final s in state) s.copyWith(showEditButtons: false),
    ];
  }
}
