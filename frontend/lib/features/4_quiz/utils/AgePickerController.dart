import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AgePickerController {
  final ValueNotifier<int> age;
  final FixedExtentScrollController scrollController;
  final int min;
  final int max;

  AgePickerController({
    required this.min,
    required this.max,
    int initialAge = 18,
  }) : age = ValueNotifier<int>(initialAge.clamp(min, max)),
        scrollController = FixedExtentScrollController(
          initialItem: initialAge.clamp(min, max) - min,
        );

  void setAge(int value, {bool animate = true}) {
    final v = value.clamp(min, max);
    age.value = v;

    final index = v - min;
    if (animate) {
      scrollController.animateToItem(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.jumpToItem(index);
    }
  }

  void dispose() {
    age.dispose();
    scrollController.dispose();
  }
}
