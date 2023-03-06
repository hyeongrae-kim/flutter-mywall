import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/view/decos_list_screen.dart';
import 'package:mywall/user/component/Image_element.dart';
import 'package:mywall/user/component/asset_image_element.dart';
import 'package:mywall/user/component/clock_element.dart';
import 'package:mywall/user/component/movie_element.dart';
import 'package:mywall/user/model/wall_element_model.dart';
import 'package:mywall/user/model/wall_status_model.dart';
import 'package:mywall/user/provider/wall_provider.dart';

const editButtonSize = 32.0;
const editIconSize = 24.0;
const elementMarginSize = editIconSize / 2;
const elementPaddingSize = editIconSize / 6;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool toggle = false;
  double angleDelta = 0;
  late Offset initPoint;

  @override
  Widget build(BuildContext context) {
    final List<WallElement> state = ref.watch(wallElementListProvider);
    final WallStatus status = ref.watch(wallStatusProvider);
    final Color textColor =
        status.color == null || status.color!.computeLuminance() >= 0.5
            ? Colors.black
            : Colors.white;

    return Scaffold(
      // appBar: renderAppBar(ref),
      backgroundColor:
          status.assetUrl == null ? status.color : Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: status.assetUrl != null
                ? BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        status.assetUrl!,
                      ),
                    ),
                  )
                : null,
          ),
          Column(
            children: [
              renderAppBar(ref),
              Expanded(
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (PointerDownEvent e) {
                    bool inChild = false;
                    for (final s in state) {
                      Rect rect = Rect.fromPoints(
                          s.elementPosition,
                          Offset(
                              s.elementPosition.dx +
                                  s.elementWidth +
                                  editButtonSize +
                                  elementMarginSize,
                              s.elementPosition.dy +
                                  s.elementWidth / s.aspectRatio +
                                  editButtonSize +
                                  elementMarginSize));
                      if (rect.contains(e.localPosition)) {
                        inChild = true;
                      }
                    }

                    if (inChild == false) {
                      ref
                          .read(wallElementListProvider.notifier)
                          .offAllShowEditButtons();
                    }
                  },
                  child: Stack(
                    children: state.isEmpty
                        ? [
                            Center(
                              child: Text(
                                'Create your wall!',
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                            ),
                          ]
                        : state.map((e) {
                            return renderElement(e);
                          }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget renderElement(WallElement e) {
    ValueKey key = ValueKey(e.id!);
    return Positioned(
      key: key,
      left: e.elementPosition.dx,
      top: e.elementPosition.dy,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(1.0)
          ..rotateZ(ref.read(wallElementListProvider.notifier).getAngle(e.id!)),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (details) {
            if (toggle) {
              ref.read(wallElementListProvider.notifier).reOrder(e.id!);
              setState(() {
                initPoint = details.focalPoint;
              });
            }
          },
          onScaleUpdate: (details) {
            if (toggle) {
              final dx = details.focalPoint.dx - initPoint.dx;
              final dy = details.focalPoint.dy - initPoint.dy;
              setState(() {
                initPoint = details.focalPoint;
              });
              Offset updatePosition = Offset(
                e.elementPosition.dx + dx,
                e.elementPosition.dy + dy,
              );
              ref
                  .read(wallElementListProvider.notifier)
                  .setPosition(e.id!, updatePosition);
            }
          },
          // onPanUpdate: (DragUpdateDetails details) {
          //   Offset updatePosition = Offset(
          //     e.elementPosition.dx + details.delta.dx,
          //     e.elementPosition.dy + details.delta.dy,
          //   );
          //   ref
          //       .read(wallElementListProvider.notifier)
          //       .updatePosition(e.id!, updatePosition);
          // },
          // onPanStart: (DragStartDetails details) {},
          // onPanDown: (DragDownDetails details) {
          //   ref.read(wallElementListProvider.notifier).reOrder(e.id!);
          //   setState(() {});
          // },
          // onPanEnd: (DragEndDetails details) {},
          child: Stack(
            children: [
              Container(
                // key: const Key('draggableResizable_child_container'),
                margin: const EdgeInsets.all(elementMarginSize),
                padding: const EdgeInsets.all(elementPaddingSize),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: e.showEditButtons! && toggle
                        ? Colors.black
                        : Colors.transparent,
                  ),
                ),
                child: selectElement(e),
              ),
              // ****************close button****************
              Positioned(
                right: 0,
                child: Offstage(
                  offstage: !(e.showEditButtons! && toggle),
                  child: GestureDetector(
                    // key: const Key('draggableResizable_delete_floatingActionIcon'),
                    onTap: () {
                      ref.read(wallElementListProvider.notifier).delete(e.id!);
                    },
                    child: Container(
                      width: editButtonSize,
                      height: editButtonSize,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Center(
                        child: Icon(
                          // 삭제 버튼
                          Icons.close_rounded,
                          color: Colors.white,
                          size: editIconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ****************size button****************
              Positioned(
                right: 0,
                bottom: 0,
                child: Offstage(
                  offstage: !(e.showEditButtons! && toggle),
                  child: GestureDetector(
                    key:
                        const Key('draggableResizable_bottomRight_resizePoint'),
                    onPanUpdate: (DragUpdateDetails details) {
                      // 위치 변경
                      Offset updatePosition = Offset(
                          e.elementPosition.dx - details.delta.dx,
                          e.elementPosition.dy - details.delta.dy);
                      ref
                          .read(wallElementListProvider.notifier)
                          .setPosition(e.id!, updatePosition);

                      // 사이즈 변경
                      ref
                          .read(wallElementListProvider.notifier)
                          .setWidth(e.id!, details.delta.dx * 2.1);
                    },
                    child: Container(
                      width: editButtonSize,
                      height: editButtonSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 1.65,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Center(
                        child: Icon(
                          // 크기 조정 버튼
                          Icons.zoom_out_map,
                          color: Colors.black,
                          size: editIconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ****************rotate button****************
              Positioned(
                child: Offstage(
                  offstage: !(e.showEditButtons! && toggle),
                  child: GestureDetector(
                    // key: const Key('draggableResizable_rotate_gestureDetector'),
                    onScaleStart: (details) {
                      final center = Offset(
                        editButtonSize / 2 +
                            editButtonSize / 2 +
                            e.elementWidth / 2,
                        (e.elementWidth / e.aspectRatio) +
                            (elementMarginSize / 2),
                      );
                      final offsetFromCenter = details.localFocalPoint - center;
                      setState(() => angleDelta =
                          e.baseAngle - offsetFromCenter.direction);
                    },
                    onScaleUpdate: (details) {
                      final center = Offset(
                        editButtonSize / 2 +
                            editButtonSize / 2 +
                            e.elementWidth / 2,
                        (e.elementWidth / e.aspectRatio) +
                            (elementMarginSize / 2),
                      );
                      final offsetFromCenter = details.localFocalPoint - center;
                      ref.read(wallElementListProvider.notifier).setAngle(
                          e.id!, offsetFromCenter.direction + angleDelta);
                    },
                    onScaleEnd: (_) {
                      ref
                          .read(wallElementListProvider.notifier)
                          .setBaseAngle(e.id!, e.angle);
                    },
                    child: Container(
                      width: editButtonSize,
                      height: editButtonSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 1.65,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Center(
                        child: Icon(
                          // 회전 버튼
                          Icons.rotate_right,
                          color: Colors.black,
                          size: editIconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectElement(WallElement e) {
    if (e.rawImg != null) {
      return ImageElement(
        rawImg: e.rawImg!,
        id: e.id!,
      );
    } else if (e.movieUrl != null) {
      return MovieElement(
        movieUrl: e.movieUrl!,
        id: e.id!,
      );
    } else if (e.assetUrl != null) {
      return AssetImageElement(
        assetUrl: e.assetUrl!,
        id: e.id!,
      );
    } else if (e.clockIndex != null) {
      return SizedBox(
        width: e.elementWidth,
        height: e.elementWidth/e.aspectRatio,
        child: ClockElement(
          id: e.id!,
        ),
      );
    } else {
      return Container();
    }
  }

  AppBar renderAppBar(WidgetRef ref) {
    final WallStatus status = ref.watch(wallStatusProvider);
    final Color textColor =
        status.color != null && status.color!.computeLuminance() >= 0.5
            ? Colors.black
            : Colors.white;

    return AppBar(
      backgroundColor:
          status.assetUrl == null ? status.color : Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: Text(
        'MyWall',
        style: TextStyle(
          fontSize: 16.0,
          color: textColor,
        ),
      ),
      actions: toggle
          ? [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.add_box_outlined,
                  color: textColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const DecorateList();
                      },
                    ),
                  );
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.save_outlined,
                  color: textColor,
                ),
                onPressed: () {
                  ref
                      .read(wallElementListProvider.notifier)
                      .offAllShowEditButtons();
                  setState(() {
                    toggle = false;
                  });
                },
              ),
            ]
          : [
              IconButton(
                icon: Icon(
                  Icons.create_outlined,
                  color: textColor,
                ),
                onPressed: () {
                  setState(() {
                    toggle = true;
                  });
                },
              ),
            ],
    );
  }
}
