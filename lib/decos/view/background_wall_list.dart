import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/user/provider/wall_provider.dart';

class BackgroundWallList extends ConsumerStatefulWidget {
  const BackgroundWallList({Key? key}) : super(key: key);

  @override
  ConsumerState<BackgroundWallList> createState() => _BackgroundWallListState();
}

class _BackgroundWallListState extends ConsumerState<BackgroundWallList> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Background Wall',
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          childAspectRatio: 1 / 1,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LayoutBuilder(builder: (context, constraints) {
              if(index==0){
                return InkWell(
                  onTap: () {
                    ref.read(wallStatusProvider.notifier).changeWallPhoto(null);
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
                      child: const Center(child: Text('no wall'),),
                    ),
                  ),
                );
              }else{
                return InkWell(
                  onTap: () {
                    ref.read(wallStatusProvider.notifier).changeWallPhoto('asset/img/wallphotos/wallphoto${index}.jpg');
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: Padding(
                    // (식) ? 왼쪽에 배치될 경우 : (식) ? 오른쪽에 배치될 경우 : 가운데에 배치될 경우
                    padding: (index+1) % 3 == 0
                        ? const EdgeInsets.only(right: 8.0)
                        : (index+1) % 3 == 1
                        ? const EdgeInsets.only(left: 8.0)
                        : const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Image.asset(
                          'asset/img/wallphotos/wallphoto${index}.jpg'),
                    ),
                  ),
                );
              }
            }),
          );
        },
      ),
    );
  }
}