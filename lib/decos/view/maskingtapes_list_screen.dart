import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/user/model/wall_element_model.dart';
import 'package:mywall/user/provider/wall_provider.dart';

class MaskingtapesListScreen extends ConsumerStatefulWidget {
  const MaskingtapesListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MaskingtapesListScreen> createState() =>
      _MaskingtapesListScreenState();
}

class _MaskingtapesListScreenState
    extends ConsumerState<MaskingtapesListScreen> {
  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    return DefaultLayout(
      title: 'Maskingtapes',
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          childAspectRatio: 1 / 1,
        ),
        itemCount: 25,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LayoutBuilder(builder: (context, constraints) {
              return InkWell(
                onTap: () {
                  onTap(maxWidth, maxHeight, constraints.maxWidth, index);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Padding(
                  // (식) ? 왼쪽에 배치될 경우 : (식) ? 오른쪽에 배치될 경우 : 가운데에 배치될 경우
                  padding: (index + 1) % 3 == 0
                      ? const EdgeInsets.only(right: 8.0)
                      : (index + 1) % 3 == 1
                          ? const EdgeInsets.only(left: 8.0)
                          : const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Image.asset(
                        'asset/img/maskingtapes/tape${index + 1}.png'),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  void onTap(double maxWidth, double maxHeight, double elementWidth, int index) async {
    ui.Image image = await getImageFromAsset(index);
    final width = image.width;
    final height = image.height;

    ref.read(wallElementListProvider.notifier).append(WallElement(
      elementPosition: Offset(
        maxWidth / 4,
        maxHeight / 4,
      ),
      elementWidth: elementWidth,
      showEditButtons: false,
      aspectRatio: width / height,
      angle: 0,
      baseAngle: 0,
      assetUrl: 'asset/img/maskingtapes/tape${index + 1}.png',
    ));
  }

  Future<ui.Image> getImageFromAsset(int index) async {
    final ByteData data =
        await rootBundle.load('asset/img/maskingtapes/tape${index + 1}.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
