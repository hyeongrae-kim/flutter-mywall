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
            : SizedBox(child: renderList(state)));
  }

  Widget renderList(List<WallElement> elements) {
    return Stack(
      children: elements
          .map((e) => e.id != null
              ? Positioned(
                  left: e.elementPosition.dx,
                  top: e.elementPosition.dy,
                  child: Draggable(
                    maxSimultaneousDrags: 1,
                    feedback: renderElement(e),
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
                      child: renderElement(e),
                    ),
                    child: renderElement(e),
                  ),
                )
              : Container(
                  child: const Text('element id error'),
                ))
          .toList(),
    );
  }

  Widget renderElement(WallElement e) {
    return GestureDetector(
      onTap: (){
        ref.read(wallElementListProvider.notifier).touchElement(e.id!);
      },
      child: Stack(
        children: [
          selectElement(e),
        ],
      ),
    );
  }

  Widget selectElement(WallElement e) {
    if (e.rawImg != null) {
      return ImageElement(rawImg: e.rawImg!);
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
