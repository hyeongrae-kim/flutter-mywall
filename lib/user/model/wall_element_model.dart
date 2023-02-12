import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 벽을 꾸밀 요소들의 타입을 묶어서 관리
// img -> rawImg
// text -> text
class WallElement {
  Uint8List? rawImg;
  Offset elementPosition;
  int? id = -1;
  bool? showEditButtons;
  double? elementWidth;

  WallElement({
    required this.rawImg,
    required this.elementPosition,
    required this.elementWidth,
    required this.showEditButtons,
    this.id,
  });

  WallElement copyWith({
    Offset? elementPosition,
    double? elementWidth,
    bool? showEditButtons,
    int? id,
  }) {
    return WallElement(
      rawImg: rawImg,
      id: id ?? this.id,
      elementPosition: elementPosition ?? this.elementPosition,
      elementWidth: elementWidth ?? this.elementWidth,
      showEditButtons: showEditButtons ?? this.showEditButtons,
    );
  }
}
