import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/utills/photo_edit_utils.dart';
import 'package:mywall/common/widget/photo_edit_commons.dart';
import 'package:mywall/user/model/wall_element_model.dart';
import 'package:mywall/user/provider/wall_provider.dart';
import 'package:mywall/user/view/home_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image/image.dart' as img;

class PhotoDecoScreen extends ConsumerStatefulWidget {
  final AssetEntity e;

  const PhotoDecoScreen({
    required this.e,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PhotoDecoScreen> createState() => _PhotoDecoScreenState();
}

class _PhotoDecoScreenState extends ConsumerState<PhotoDecoScreen> {
  bool showMenus = true;
  bool cropOnPressed = false;

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  Uint8List? _memoryImage;
  final List<AspectRatioItem> _aspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: 'Free', value: CropAspectRatios.custom),
    AspectRatioItem(text: '1:1', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '4:3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3:4', value: CropAspectRatios.ratio3_4),
  ];
  AspectRatioItem? _aspectRatio;
  EditorCropLayerPainter? _cropLayerPainter;
  bool _cropping = false;
  File? _imgFile;

  Future<void> _getImage() async {
    _memoryImage ??= await widget.e.originBytes;
    _imgFile = await widget.e.file;
    setState(() {});
    //when back to current page, may be editorKey.currentState is not ready.
    // Future<void>.delayed(const Duration(milliseconds: 200), () {
    //   setState(() {
    //     editorKey.currentState!.reset();
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();
    _aspectRatio = _aspectRatios.first;
    _cropLayerPainter = const EditorCropLayerPainter();
    _getImage();
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _memoryImage != null
                ? cropOnPressed
                    ? Expanded(
                        child: ExtendedImage.memory(
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
                              cornerColor: Colors.white,
                              lineColor: Colors.white,
                            );
                          },
                          cacheRawData: true,
                        ),
                      )
                    : Center(
                        child: Image.memory(_memoryImage!),
                      )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            cropOnPressed == true ? showCropOptions() : const SizedBox(),
          ],
        ),
        appBar:
            showMenus == true || cropOnPressed == true ? renderAppBar() : null,
        bottomNavigationBar: showMenus == true || cropOnPressed == true
            ? renderBottomAppBar()
            : null,
        extendBody: cropOnPressed == false ? true : false,
        extendBodyBehindAppBar: cropOnPressed == false ? true : false,
      ),
    );
  }

  rotateImage() async {
    // File? file = await widget.e.file;
    if (_imgFile == null) {
      print('null error');
      return;
    }
    // Uint8List imageBytes = await file.readAsBytes();
    // Uint8List imageBytes = await _imgFile!.readAsBytes();
    final originalImage = img.decodeImage(_memoryImage!);
    img.Image? fixedImage;
    fixedImage = img.copyRotate(originalImage!, angle: 90);
    File fixedFile = await _imgFile!.writeAsBytes(
      img.encodeJpg(fixedImage),
      flush: true,
    );

    setState(() {
      _memoryImage = fixedFile.readAsBytesSync();
    });
  }

  Future<void> _cropImage() async {
    if (_cropping) {
      return;
    }
    String msg = '';
    try {
      _cropping = true;
      Uint8List? fileData;
      fileData =
          await cropImageDataWithNativeLibrary(state: editorKey.currentState!);
      setState(() {
        _memoryImage = fileData;
      });
    } catch (e, stack) {
      msg = 'crop failed: $e\n $stack';
      print(msg);
    }
    _cropping = false;
  }

  Widget showCropOptions() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(18.0),
        itemBuilder: (_, int index) {
          final AspectRatioItem item = _aspectRatios[index];
          return GestureDetector(
            child: AspectRatioWidget(
              aspectRatio: item.value,
              aspectRatioS: item.text,
              isSelected: item == _aspectRatio,
            ),
            onTap: () {
              setState(() {
                _aspectRatio = item;
              });
            },
          );
        },
        itemCount: _aspectRatios.length,
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
            onPressed: () {
              setState(() {
                cropOnPressed = !cropOnPressed;
              });
            },
            icon: const Icon(
              Icons.crop,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              rotateImage();
            },
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
      title: cropOnPressed
          ? const Text(
              '자르기',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            )
          : const Text(
              '사진 편집',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
      leading: cropOnPressed
          ? TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                  cropOnPressed = !cropOnPressed;
                });
              },
            )
          : IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back_ios_outlined),
              iconSize: 16.0,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
      actions: [
        // 완료 버튼. 편집 시 편집완료, 편집하고있지 않을 시 홈으로 사진데이터 보내기
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          onPressed: () {
            if (cropOnPressed) {
              // 사진 crop
              setState(() {
                _cropImage();
                cropOnPressed = !cropOnPressed;
              });
            } else {
              // 사진편집 완료 후 홈으로 이동
              ref.read(wallElementListProvider.notifier).append(WallElement(
                    rawImg: _memoryImage,
                    showEditButtons: false,
                    elementWidth: MediaQuery.of(context).size.width/(1.5),
                    elementPosition: Offset(
                      MediaQuery.of(context).size.width / 4,
                      MediaQuery.of(context).size.height / 4,
                    ),
                  ));
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }
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
