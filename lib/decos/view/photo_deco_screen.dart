import 'package:flutter/material.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoDecoScreen extends StatefulWidget {
  final AssetEntity e;

  const PhotoDecoScreen({
    required this.e,
    Key? key,
  }) : super(key: key);

  @override
  State<PhotoDecoScreen> createState() => _PhotoDecoScreenState();
}

class _PhotoDecoScreenState extends State<PhotoDecoScreen> {
  bool showMenus = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showMenus = !showMenus;
        });
      },
      child: DefaultLayout(
        body: Stack(
          children: [
            Center(
              child: AssetEntityImage(
                widget.e,
              ),
            ),
            if (showMenus == true) _topBar(),
            if (showMenus == true) _bottomBar(),
          ],
        ),
        title: '사진 편집',
        showAppBar: false,
      ),
    );
  }

  Widget _topBar() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back_ios_outlined),
            iconSize: 16.0,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Text(
            '사진 편집',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            onPressed: () {
              print('완료');
            },
            child: const Text(
              '완료',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.auto_fix_high,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.crop,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.rotate_left,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.text_fields,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.filter_frames,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
