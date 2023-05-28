import 'package:flutter/animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../models/verse_reference_model.dart';

class VerseListControllerNotifier extends StateNotifier<ItemScrollController> {
  VerseListControllerNotifier() : super(ItemScrollController());

  void scrollToOffset(String verseString) {
    VerseRange verseRange;

    List<String> num = verseString.split('-');

    if (num.length == 2) {
      verseRange = (start: int.tryParse(num[0]) ?? 1, end: int.tryParse(num[1]));
    } else {
      verseRange = (start: int.tryParse(num[0]) ?? 1, end: null);
    }

    if (verseRange.end == null) {
      state.scrollTo(index: verseRange.start - 1, duration: const Duration(milliseconds: 100), curve: Curves.linear);
      return;
    } else {
      int index = verseRange.end! - 4;

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
