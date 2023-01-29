import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/view/decos_list_screen.dart';
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
          ? Center(
              child: Text('Create your wall!'),
            )
          : Center(
              child: Image.memory(
                state[0].rawImg!,
              ),
            ),
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
