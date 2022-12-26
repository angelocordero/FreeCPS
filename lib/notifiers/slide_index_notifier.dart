import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/slide_model.dart';

class SlideIndexNotifier extends StateNotifier<int?> {
  SlideIndexNotifier() : super(null);

  void project(int index, Slide slide) async {
    if (index == state) return;

    try {
      state = index;
      int windowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

      await DesktopMultiWindow.invokeMethod(windowID, 'verseSlide', slide.text);
    } catch (e) {
//
    }
  }
}
