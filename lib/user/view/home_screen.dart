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

  double dx = 0;
  double dy = 0;

  @override
  Widget build(BuildContext context) {
    final List<WallElement> state = ref.watch(wallElementListProvider);

    return DefaultLayout(
        title: 'MyWall',
        renderAppBar: renderAppBar(),
        body: state.isEmpty
            ? const Center(
                child: Text('Create your wall!'),
              )
            : SizedBox(child: renderList(state)));
  }

  Widget renderList(List<WallElement> elements) {
    return Stack(
      children: elements
          .map((e) => e.id != null
              ? Positioned(
                  left: e.elementPosition.dx - dx,
                  top: e.elementPosition.dy - dy,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(wallElementListProvider.notifier)
                          .changePriority(e.id!);
                    },
                    child: Draggable(
                      maxSimultaneousDrags: 1,
                      // 움직이는 도중엔 테두리 보이도록
                      feedback: renderElement(e, true),
                      onDragStarted: () {
                        // 움직이는 도중에 원래 포커스 되어있던 element 포커스 빼기
                        setState(() {
                          ref
                              .read(wallElementListProvider.notifier)
                              .changeShowEditButtons(e.id!);
                        });
                      },
                      onDragEnd: (details) => ref
                          .read(wallElementListProvider.notifier)
                          .updatePosition(
                            e.id!,
                            Offset(
                              details.offset.dx,
                              details.offset.dy -
                                  renderAppBar().preferredSize.height -
                                  MediaQuery.of(context).padding.top,
                            ),
                          ),
                      childWhenDragging: Opacity(
                        opacity: 0,
                        child: renderElement(e, false),
                      ),
                      child: renderElement(e, false),
                    ),
                  ),
                )
              : Container(
                  child: const Text('element id error'),
                ))
          .toList(),
    );
  }

  Widget renderElement(WallElement e, bool forceTouch) {
    if (e.elementWidth == null) {
      print('width error');
      return Container(
        child: Text('width error'),
      );
    }
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(e.elementWidth! / 20),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: e.showEditButtons || forceTouch
                  ? Colors.black
                  : Colors.transparent,
            ),
          ),
          child: selectElement(e),
        ),
        Positioned(
          right: 0,
          child: Offstage(
            offstage: !(e.showEditButtons || forceTouch),
            child: GestureDetector(
              onTap: () {
                print('click close button');
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
            offstage: !(e.showEditButtons || forceTouch),
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  print(details.delta);
                  dx = details.delta.dx;
                  dy = details.delta.dy;
                  ref.read(wallElementListProvider.notifier).setWidth(e.id!, dx);
                });
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
                  borderRadius: BorderRadius.circular(e.elementWidth! / 8 / 2),
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
