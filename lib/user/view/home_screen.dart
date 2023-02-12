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
      body: state.isEmpty
          ? const Center(
              child: Text('Create your wall!'),
            )
          : renderList(state),
    );
  }

  Widget renderList(List<WallElement> elements) {
    setState(() {

    });
    return Stack(
      children: elements
          .map((e) => e.id != null
              ? RenderElement(e: e)
              : Container(
                  child: const Text('element id error'),
                ))
          .toList(),
    );
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

class RenderElement extends ConsumerStatefulWidget {
  final WallElement e;

  const RenderElement({
    required this.e,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RenderElement> createState() => _RenderElementState();
}

class _RenderElementState extends ConsumerState<RenderElement> {


  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.e.elementPosition.dx,
      top: widget.e.elementPosition.dy,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanDown: _onPanDown,
        onPanEnd: _onPanEnd,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(widget.e.elementWidth! / 20),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (ref.read(wallElementListProvider.notifier).getShowEditButtons(widget.e.id!))!
                      ? Colors.black
                      : Colors.transparent,
                ),
              ),
              child: selectElement(widget.e),
            ),
            Positioned(
              right: 0,
              child: Offstage(
                offstage: !(ref.read(wallElementListProvider.notifier).getShowEditButtons(widget.e.id!)),
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(wallElementListProvider.notifier)
                        .delete(widget.e.id!);
                  },
                  child: Container(
                    width: widget.e.elementWidth! / 8,
                    height: widget.e.elementWidth! / 8,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(
                            widget.e.elementWidth! / 8 / 2)),
                    child: Center(
                      child: Icon(
                        // 삭제 버튼
                        Icons.close_rounded,
                        color: Colors.white,
                        size: widget.e.elementWidth! / 8 - 5,
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
                offstage: !(ref.read(wallElementListProvider.notifier).getShowEditButtons(widget.e.id!)),
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details){
                    Offset updatePosition = Offset(widget.e.elementPosition.dx - details.delta.dx,
                        widget.e.elementPosition.dy - details.delta.dy);
                    ref.read(wallElementListProvider.notifier).updatePosition(widget.e.id!, updatePosition);
                    ref.read(wallElementListProvider.notifier).setWidth(widget.e.id!, details.delta.dx*2);
                  },
                  child: Container(
                    width: widget.e.elementWidth! / 8,
                    height: widget.e.elementWidth! / 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 1.65,
                        ),
                      ],
                      borderRadius:
                          BorderRadius.circular(widget.e.elementWidth! / 8 / 2),
                    ),
                    child: Center(
                      child: Icon(
                        // 삭제 버튼
                        Icons.zoom_out_map,
                        color: Colors.black,
                        size: widget.e.elementWidth! / 10,
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

  _onPanUpdate(DragUpdateDetails details) {
    Offset updatePosition = Offset(widget.e.elementPosition.dx + details.delta.dx,
        widget.e.elementPosition.dy + details.delta.dy);
    ref
        .read(wallElementListProvider.notifier)
        .updatePosition(widget.e.id!, updatePosition);
  }

  _onPanDown(DragDownDetails details) {

    setState(() {
      ref.read(wallElementListProvider.notifier).changeShowEditButtons(widget.e.id!);
    });
  }

  _onPanEnd(DragEndDetails details) {
    ref.read(wallElementListProvider.notifier).changePriority(widget.e.id!);
    setState(() {});
  }
}
