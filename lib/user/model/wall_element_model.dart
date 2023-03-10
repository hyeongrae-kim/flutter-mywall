import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 벽을 꾸밀 요소들의 타입을 묶어서 관리
// img -> rawImg
// text -> text
class WallElement {
  // element 종류
  Uint8List? rawImg;
  String? movieUrl;
  String? assetUrl;
  int? clockIndex;

  // 공통 속성
  Offset elementPosition;
  int? id = -1;
  bool? showEditButtons;
  double elementWidth;
  double aspectRatio;
  double angle;
  double baseAngle;

  WallElement({
    this.rawImg,
    this.movieUrl,
    this.assetUrl,
    this.clockIndex,
    required this.elementPosition,
    required this.elementWidth,
    required this.showEditButtons,
    required this.aspectRatio,
    required this.angle,
    required this.baseAngle,
    this.id,
  });

  WallElement copyWith({
    Offset? elementPosition,
    double? elementWidth,
    bool? showEditButtons,
    int? id,
    double? aspectRatio,
    double? angle,
    double? baseAngle,
  }) {
    return WallElement(
      rawImg: rawImg,
      movieUrl: movieUrl,
      assetUrl: assetUrl,
      clockIndex: clockIndex,
      id: id ?? this.id,
      elementPosition: elementPosition ?? this.elementPosition,
      elementWidth: elementWidth ?? this.elementWidth,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      angle: angle ?? this.angle,
      baseAngle: baseAngle ?? this.baseAngle,
      showEditButtons: showEditButtons ?? this.showEditButtons,
    );
  }
}
