import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 벽을 꾸밀 요소들의 타입을 묶어서 관리
// img -> rawImg
// text -> text
class WallElement {
  Uint8List? rawImg;
  Offset elementPosition;
  int? id = -1;
  bool showEditButtons;

  WallElement({
    required this.rawImg,
    required this.elementPosition,
    required this.showEditButtons,
    this.id,
  });

}