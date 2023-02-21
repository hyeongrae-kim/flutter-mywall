import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/view/decos_list_screen.dart';
import 'package:mywall/user/component/Image_element.dart';
import 'package:mywall/user/component/movie_element.dart';
import 'package:mywall/user/model/wall_element_model.dart';
import 'package:mywall/user/provider/wall_provider.dart';

const editButtonSize = 32.0;
const editIconSize = 24.0;
const elementMarginSize = editIconSize/2;
const elementPaddingSize = editIconSize/2;

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
  Offset? center;
  late Offset initPoint;

  @override
  Widget build(BuildContext context) {
    final List<WallElement> state = ref.watch(wallElementListProvider);

    return DefaultLayout(
      title: 'MyWall',
      renderAppBar: renderAppBar(),
      body: Stack(
        children: state.isEmpty
            ? [
                const Center(
                  child: Text('Create your wall!'),
                ),
              ]
            : state.map((e) {
                return renderElement(e);
              }).toList(),
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
          onScaleStart: (details){
            ref.read(wallElementListProvider.notifier).reOrder(e.id!);
            setState(() {
              initPoint = details.focalPoint;
            });
          },
          onScaleUpdate: (details){
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
                    color:
                        e.showEditButtons! ? Colors.black : Colors.transparent,
                  ),
                ),
                child: selectElement(e),
              ),
              // ****************close button****************
              Positioned(
                right: 0,
                child: Offstage(
                  offstage: !(e.showEditButtons!),
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
                  offstage: !(e.showEditButtons!),
                  child: GestureDetector(
                    key: const Key('draggableResizable_bottomRight_resizePoint'),
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
                        borderRadius:
                            BorderRadius.circular(16.0),
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
                  offstage: !(e.showEditButtons!),
                  child: GestureDetector(
                    // key: const Key('draggableResizable_rotate_gestureDetector'),
                    onScaleStart: (details) {
                      final center = Offset(
                        editButtonSize/2 + editButtonSize/2 + e.elementWidth/2,
                        (e.elementWidth/e.aspectRatio) + (elementMarginSize/2),
                      );
                      final offsetFromCenter = details.localFocalPoint - center;
                      setState(() =>
                          angleDelta = e.baseAngle - offsetFromCenter.direction);
                    },
                    onScaleUpdate: (details) {
                      final center = Offset(
                        editButtonSize/2 + editButtonSize/2 + e.elementWidth/2,
                        (e.elementWidth/e.aspectRatio) + (elementMarginSize/2),
                      );
                      final offsetFromCenter = details.localFocalPoint - center;
                      ref.read(wallElementListProvider.notifier).setAngle(e.id!, offsetFromCenter.direction + angleDelta);
                    },
                    onScaleEnd: (_) {
                      ref.read(wallElementListProvider.notifier).setBaseAngle(e.id!, e.angle);
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
                        borderRadius:
                            BorderRadius.circular(16.0),
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
    } else {
      return Container();
    }
  }

  AppBar renderAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Text(
        'MyWall',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      actions: toggle
          ? [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return DecorateList();
                      },
                    ),
                  );
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.save_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
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
                  color: Colors.black,
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
