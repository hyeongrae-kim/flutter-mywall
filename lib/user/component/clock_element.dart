import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClockElement extends ConsumerStatefulWidget {
  final int id;

  const ClockElement({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ClockElement> createState() => _ClockElementState();
}

class _ClockElementState extends ConsumerState<ClockElement>
    with TickerProviderStateMixin {
  late final ctrl = AnimationController.unbounded(vsync: this);

  @override
  void initState() {
    super.initState();
    _startTime();
  }

  _startTime() async {
    // print('_startTime');
    while (true) {
      final now = DateTime.now();
      final ms = 1000 - now.millisecond; // 1000ms=1s
      // print('wait ${ms}ms');
      await Future.delayed(Duration(milliseconds: ms));
      await ctrl.animateTo(
        (ctrl.value + 1).roundToDouble(),
        duration: const Duration(milliseconds: 400),
        curve: (ctrl.value % 20) < 10 ? Curves.elasticOut : Curves.bounceOut,
      );
      // print(ctrl.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: ClockDelegate(ctrl),
      children: [
        Image.file(
          File(
              '/Users/hyeongraekim/flutter_project/mywall/asset/img/clock/clock1.png'),
        ),
        Image.file(File('/Users/hyeongraekim/flutter_project/mywall/asset/img/clock/hour_hand1.png')),
        Image.file(File('/Users/hyeongraekim/flutter_project/mywall/asset/img/clock/minute_hand1.png')),
        Image.file(File('/Users/hyeongraekim/flutter_project/mywall/asset/img/clock/second_hand1.png')),
      ],
    );
  }
}

class ClockDelegate extends FlowDelegate {
  ClockDelegate(this.ctrl) : super(repaint: ctrl);

  final AnimationController ctrl;

  @override
  void paintChildren(FlowPaintingContext context) {
    DateTime now = DateTime.now();
    final center = context.size.center(Offset.zero);
    // print(center);

    // paint clock
    context.paintChild(0);

    // paint hour hand
    final hourSize = context.getChildSize(1)!;
    final hourMatrix = composeMatrixFromOffsets(
      rotation: ((2*pi/12)*(now.hour%12)+(2 * pi / 60)*now.minute/12) ,
      translate: center,
      anchor: hourSize.center(Offset(0, hourSize.height/3.8)),
      scale: context.size.shortestSide*0.3 / hourSize.width,
    );
    context.paintChild(1, transform: hourMatrix);

    // paint minute hand
    final minutesSize = context.getChildSize(2)!;
    final minutesMatrix = composeMatrixFromOffsets(
      rotation: (2*pi/60)*now.minute,
      translate: center,
      anchor: minutesSize.center(Offset(0, minutesSize.height/3)),
      scale: context.size.shortestSide * 0.4 / minutesSize.width,
    );
    context.paintChild(2, transform: minutesMatrix);

    // paint second hand
    final secondsSize = context.getChildSize(3)!;
    final secondsMatrix = composeMatrixFromOffsets(
      rotation: (2*pi/60)*now.second,
      translate: center,
      anchor:  secondsSize.center(Offset(0, secondsSize.height/3)),
      scale: context.size.shortestSide * 0.4 / secondsSize.width, // 2.25
    );
    context.paintChild(3, transform: secondsMatrix);
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}

// RSTransform.fromComponents constructor 와 동일한 알고리즘.
Matrix4 composeMatrixFromOffsets({
  double scale = 1,
  double rotation = 0,
  Offset translate = Offset
      .zero, // give the coordinate(좌표) of the offset by which to translate.
  Offset anchor = Offset
      .zero, //  give the coordinate(좌표) of the point around which to rotate.
}) {
  final double c = cos(rotation) * scale;
  final double s = sin(rotation) * scale;
  final double dx = translate.dx - c * anchor.dx + s * anchor.dy;
  final double dy = translate.dy - s * anchor.dx - c * anchor.dy;

  //  ..[0]  = c       # x scale(크기)
  //  ..[1]  = s       # y skew(기울임)
  //  ..[4]  = -s      # x skew(기울임)
  //  ..[5]  = c       # y scale(크기)
  //  ..[10] = 1       # diagonal "one" (Z 축으로의 확대/축소 비율(factor))
  //  ..[12] = dx      # x translation(이동)
  //  ..[13] = dy      # y translation(이동)
  //  ..[15] = 1       # diagonal "one"
  return Matrix4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
}
