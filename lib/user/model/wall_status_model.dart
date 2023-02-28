import 'package:flutter/material.dart';

class WallStatus {
  Color? color;
  String? assetUrl;

  WallStatus({
    this.color,
    this.assetUrl,
  });

  WallStatus copyWith({
    Color? color,
    String? assetUrl,
  }) {
    return WallStatus(
      color: color ?? this.color,
      assetUrl: assetUrl,
    );
  }
}
