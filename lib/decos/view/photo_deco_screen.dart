import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mywall/common/widget/photo_edit_commons.dart';
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

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  Uint8List? _memoryImage;
  final List<AspectRatioItem> _aspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: 'custom', value: CropAspectRatios.custom),
    AspectRatioItem(text: 'original', value: CropAspectRatios.original),
    AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
    AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
  ];
  AspectRatioItem? _aspectRatio;
  EditorCropLayerPainter? _cropLayerPainter;

  Future<void> _getImage() async {
    _memoryImage = await widget.e.originBytes;
    //when back to current page, may be editorKey.currentState is not ready.
    // Future<void>.delayed(const Duration(milliseconds: 200), () {
    //   setState(() {
    //     editorKey.currentState!.reset();
    //   });
    // });
  }

  @override
  void initState() {
    _aspectRatio = _aspectRatios.first;
    _cropLayerPainter = const EditorCropLayerPainter();
    _getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showMenus = !showMenus;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Center(
            //   child: AssetEntityImage(
            //     widget.e,
            //   ),
            // ),
            _memoryImage != null
                ? ExtendedImage.memory(
                    _memoryImage!,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    enableLoadState: true,
                    extendedImageEditorKey: editorKey,
                    initEditorConfigHandler: (ExtendedImageState? state) {
                      return EditorConfig(
                        maxScale: 8.0,
                        cropRectPadding: const EdgeInsets.all(20.0),
                        hitTestSize: 20.0,
                        cropLayerPainter: _cropLayerPainter!,
                        initCropRectType: InitCropRectType.imageRect,
                        cropAspectRatio: _aspectRatio!.value,
                      );
                    },
                    cacheRawData: true,
                  )
                : const Center(
                    child: Text('Error on loading image!!'),
                  ),
          ],
        ),
        appBar: showMenus == true ? renderAppBar() : null,
        bottomNavigationBar: showMenus == true ? renderBottomAppBar() : null,
        extendBody: true,
        extendBodyBehindAppBar: true,
      ),
    );
  }

  BottomAppBar renderBottomAppBar() {
    return BottomAppBar(
      color: Colors.black.withOpacity(0.55),
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
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      backgroundColor: Colors.black.withOpacity(0.55),
      elevation: 0,
      title: const Text(
        '사진 편집',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        color: Colors.white,
        icon: Icon(Icons.arrow_back_ios_outlined),
        iconSize: 16.0,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
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
    );
  }
}
