import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/user/provider/wall_provider.dart';

class BackgroundColorList extends ConsumerStatefulWidget {
  const BackgroundColorList({Key? key}) : super(key: key);

  @override
  ConsumerState<BackgroundColorList> createState() => _BackgroundColorListState();
}

class _BackgroundColorListState extends ConsumerState<BackgroundColorList> {
  late Color screenPickerColor; // Color for picker shown in Card on the screen.

  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
  <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  Color _selectedColor = const Color(0xFFA239CA);
  ColorSwatch<Object>? _activeSwatch;

  // Set to true when we are drag and operating the wheel picker.
  bool _onWheel = false;

  bool isGuide = true;

  @override
  void initState() {
    screenPickerColor = Colors.blue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: 'Background Color',
        renderAppBar: renderAppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isGuide = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: isGuide ? Colors.black : Colors.grey,
                      ),
                      child: const Text('Guide'),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  const Text('|'),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isGuide = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: isGuide ? Colors.grey : Colors.black,
                      ),
                      child: const Text('Custom'),
                    ),
                  ),
                ],
              ),
            ),
            isGuide ? guideColors() : customColors(),
          ],
        ));
  }

  Widget guideColors() {
    return ColorPicker(
      // Use the screenPickerColor as start color.
      color: screenPickerColor,
      // Update the screenPickerColor using the callback.
      onColorChanged: (Color color) =>
          setState(() => screenPickerColor = color),
      width: 44,
      height: 44,
      columnSpacing: 16,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: false,
      },
      subheading: Text(
        'Select color shade',
        style: Theme
            .of(context)
            .textTheme
            .titleMedium,
      ),
      customColorSwatchesAndNames: colorsNameMap,
      pickerTypeLabels: const {ColorPickerType.custom: 'Sample'},
    );
  }

  Widget customColors() {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width / 10 * 9,
            height: MediaQuery
                .of(context)
                .size
                .width / 10 * 9,
            child: ColorWheelPicker(
              color: _selectedColor.withAlpha(0xFF),
              wheelSquarePadding: 8.0,
              onChangeStart: (Color color) {
                setState(() => screenPickerColor = color);
              },
              onChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                  screenPickerColor = _selectedColor;
                });
              },
              onChangeEnd: (Color color) {
                setState(() => screenPickerColor = color);
              },
              onWheel: (bool value) {
                setState(() {
                  _onWheel = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Background Color',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        color: Colors.black,
        icon: const Icon(Icons.arrow_back_ios_outlined),
        iconSize: 16.0,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.save_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            ref.read(wallStatusProvider.notifier).changeColor(screenPickerColor);
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ],
    );
  }
}