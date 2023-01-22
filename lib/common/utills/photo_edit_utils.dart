import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:image_editor/image_editor.dart';

Future<Uint8List?> cropImageDataWithNativeLibrary(
    {required ExtendedImageEditorState state}) async {
  print('native library start cropping');
  Rect cropRect = state.getCropRect()!;
  if (state.widget.extendedImageState.imageProvider is ExtendedResizeImage) {
    final ImmutableBuffer buffer =
    await ImmutableBuffer.fromUint8List(state.rawImageData);
    final ImageDescriptor descriptor = await ImageDescriptor.encoded(buffer);

    final double widthRatio = descriptor.width / state.image!.width;
    final double heightRatio = descriptor.height / state.image!.height;
    cropRect = Rect.fromLTRB(
      cropRect.left * widthRatio,
      cropRect.top * heightRatio,
      cropRect.right * widthRatio,
      cropRect.bottom * heightRatio,
    );
  }

  final EditActionDetails action = state.editAction!;

  final int rotateAngle = action.rotateAngle.toInt();
  final bool flipHorizontal = action.flipY;
  final bool flipVertical = action.flipX;
  final Uint8List img = state.rawImageData;

  final ImageEditorOption option = ImageEditorOption();

  if (action.needCrop) {
    option.addOption(ClipOption.fromRect(cropRect));
  }

  if (action.needFlip) {
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
  }

  if (action.hasRotateAngle) {
    option.addOption(RotateOption(rotateAngle));
  }

  final DateTime start = DateTime.now();
  final Uint8List? result = await ImageEditor.editImage(
    image: img,
    imageEditorOption: option,
  );

  print('${DateTime.now().difference(start)} ：total time');
  return result;
}