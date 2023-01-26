import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 벽을 꾸밀 요소들의 타입을 묶어서 관리
// img -> rawImg
// text -> text
class WallElement {
  Uint8List? rawImg;

  WallElement({
    required this.rawImg,
  });
}