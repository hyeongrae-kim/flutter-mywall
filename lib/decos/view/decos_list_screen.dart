import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/view/background_color_list.dart';
import 'package:mywall/decos/view/background_wall_list.dart';
import 'package:mywall/decos/view/maskingtapes_list_screen.dart';
import 'package:mywall/decos/view/movie_select_screen.dart';
import 'package:mywall/decos/view/photo_select_screen.dart';
import 'package:mywall/user/model/wall_element_model.dart';
import 'package:mywall/user/provider/wall_provider.dart';
import 'dart:ui' as ui;

class DecorateList extends ConsumerWidget {

  const DecorateList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tmpWidth = MediaQuery.of(context).size.width/(1.5);
    ui.Image? clockImage;

    clockOnTap() async {
      ByteData data = await rootBundle.load('/Users/hyeongraekim/flutter_project/mywall/asset/img/clock/clock1.png');
      Uint8List bytes = data.buffer.asUint8List();
      ui.Codec codec = await ui.instantiateImageCodec(bytes);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      clockImage = frameInfo.image;

      ref.read(wallElementListProvider.notifier).append(
        WallElement(
          clockIndex: 1,
          elementPosition: Offset(
            tmpWidth/2,
            tmpWidth/2,
          ),
          elementWidth: tmpWidth,
          showEditButtons: false,
          aspectRatio: clockImage!.width/clockImage!.height,
          angle: 0,
          baseAngle: 0,
        ),
      );
    }

    return DefaultLayout(
      title: 'DecoList',
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return BackgroundColorList();
                  },
                ),
              );
            },
            child: const ListTile(
              title: Text('Background Color'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return BackgroundWallList();
                  },
                ),
              );
            },
            child: const ListTile(
              title: Text('Background Wall'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MovieSelectScreen();
                  },
                ),
              );
            },
            child: const ListTile(
              title: Text('Movie Photos'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PhotoSelectScreen();
                  },
                ),
              );
            },
            child: const ListTile(
              title: Text('Photos'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: (){
              clockOnTap();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: const ListTile(
              title: Text('Clock'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MaskingtapesListScreen();
                  },
                ),
              );
            },
            child: const ListTile(
              title: Text('MaskingTapes'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}
