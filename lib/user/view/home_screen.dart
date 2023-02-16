import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/view/decos_list_screen.dart';
import 'package:mywall/user/component/Image_element.dart';
import 'package:mywall/user/model/wall_element_model.dart';
import 'package:mywall/user/provider/wall_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool toggle = false;

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
            : state
                .map((e) => e.id != null
                    ? renderElement(e)
                    : Container(
                        child: const Text('element id error'),
                      ))
                .toList(),
      ),
    );
  }

  Widget renderElement(WallElement e) {
    return Positioned(
      left: e.elementPosition.dx,
      top: e.elementPosition.dy,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset updatePosition = Offset(
            e.elementPosition.dx + details.delta.dx,
            e.elementPosition.dy + details.delta.dy,
          );
          ref
              .read(wallElementListProvider.notifier)
              .updatePosition(e.id!, updatePosition);
        },
        onPanStart: (DragStartDetails details){
        },
        onPanDown: (DragDownDetails details) {
          setState(() {
            ref
                .read(wallElementListProvider.notifier)
                .changeShowEditButtons(e.id!);
          });
        },
        onPanEnd: (DragEndDetails details) {
          ref.read(wallElementListProvider.notifier).changePriority(e.id!);
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(e.elementWidth! / 20),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: e.showEditButtons!
                      ? Colors.black
                      : Colors.transparent,
                ),
              ),
              child: selectElement(e),
            ),
            Positioned(
              right: 0,
              child: Offstage(
                offstage: !(e.showEditButtons!),
                child: GestureDetector(
                  onTap: () {
                    ref.read(wallElementListProvider.notifier).delete(e.id!);
                  },
                  child: Container(
                    width: e.elementWidth! / 8,
                    height: e.elementWidth! / 8,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius:
                            BorderRadius.circular(e.elementWidth! / 8 / 2)),
                    child: Center(
                      child: Icon(
                        // 삭제 버튼
                        Icons.close_rounded,
                        color: Colors.white,
                        size: e.elementWidth! / 8 - 5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Offstage(
                offstage: !(e.showEditButtons!),
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    // 위치 변경
                    Offset updatePosition = Offset(
                        e.elementPosition.dx - details.delta.dx,
                        e.elementPosition.dy - details.delta.dy);
                    ref
                        .read(wallElementListProvider.notifier)
                        .updatePosition(e.id!, updatePosition);

                    // 사이즈 변경
                    ref
                        .read(wallElementListProvider.notifier)
                        .setWidth(e.id!, details.delta.dx * 2);
                  },
                  child: Container(
                    width: e.elementWidth! / 8,
                    height: e.elementWidth! / 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 1.65,
                        ),
                      ],
                      borderRadius:
                          BorderRadius.circular(e.elementWidth! / 8 / 2),
                    ),
                    child: Center(
                      child: Icon(
                        // 삭제 버튼
                        Icons.zoom_out_map,
                        color: Colors.black,
                        size: e.elementWidth! / 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
