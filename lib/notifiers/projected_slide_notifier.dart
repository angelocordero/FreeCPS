import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/projection_utils.dart';

import '../models/slide_model.dart';

class ProjectedSlideNotifier extends StateNotifier<int?> {
  ProjectedSlideNotifier() : super(null);

  void project(int index, Slide slide) {
    if (index == state) return;

    try {
      state = index;

      ProjectionUtils.showSlide(slide.text);
    } catch (e) {
//
    }
  }

  void clearSlide() {
    state = null;
    ProjectionUtils.clearSlide();
  }
}
