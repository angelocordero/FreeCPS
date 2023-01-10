import 'package:flutter/animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../core/typedefs.dart';

class VerseListControllerNotifier extends StateNotifier<ItemScrollController> {
  VerseListControllerNotifier() : super(ItemScrollController());

  void scrollToOffset(String verseString) {
    VerseRange verseRange;

    List<String> num = verseString.split('-');

    if (num.length == 2) {
      verseRange = VerseRange(int.tryParse(num[0]) ?? 1, int.tryParse(num[1]));
    } else {
      verseRange = VerseRange(int.tryParse(num[0]) ?? 1, null);
    }

    if (verseRange.item2 == null) {
      state.scrollTo(index: verseRange.item1 - 1, duration: const Duration(milliseconds: 100), curve: Curves.linear);
      return;
    } else {
      int index = verseRange.item2! - 4;

      if (index <= 0) {
        state.scrollTo(index: 0, duration: const Duration(milliseconds: 100), curve: Curves.linear);
        return;
      } else {
        state.scrollTo(index: index, duration: const Duration(milliseconds: 100), curve: Curves.linear);
        return;
      }
    }
  }
}
