import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/projection_utils.dart';

import '../models/slide_model.dart';

class ProjectedSlideNotifier extends StateNotifier<int?> {
  ProjectedSlideNotifier(this.slides, this.isLive) : super(null);

  List<Slide> slides;
  bool isLive;

  void project(int index) {
    if (index == state) return;

    state = index;

    ProjectionUtils.showSlide(slides[index].text, isLive);
  }

  void clearSlide(isLive) {
    state = null;
    ProjectionUtils.clearSlide(isLive);
  }

  void up() {
    if (state == null) return;

    int index = state! - 4;

    if (index < 0) {
      return;
    }

    state = index;
    ProjectionUtils.showSlide(slides[index].text, isLive);
  }

  void down() {
    if (state == null) return;

    int index = state! + 4;

    if (index > slides.length) {
      return;
    }

    state = index;
    ProjectionUtils.showSlide(slides[index].text, isLive);
  }

  void left() {
    if (state == null) return;

    int index = state! - 1;

    if (index < 0) {
      return;
    }

    state = index;
    ProjectionUtils.showSlide(slides[index].text, isLive);
  }

  void right() {
    if (state == null) return;

    int index = state! + 1;

    if (index > slides.length - 1) {
      return;
    }

    state = index;
    ProjectionUtils.showSlide(slides[index].text, isLive);
  }
}
