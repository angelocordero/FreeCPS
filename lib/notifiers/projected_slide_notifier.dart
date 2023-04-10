import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/projection_utils.dart';
import '../models/slide_model.dart';

/// Project the slides when selected either by clicking or using arrow keys
// TODO add feature to project slides based on hotkeys
// for example, pressing "1" could jump to the first verse
class ProjectedSlideNotifier extends StateNotifier<int?> {
  ProjectedSlideNotifier(this.slides, this.isLive) : super(null);

  bool isLive;
  List<Slide> slides;

  void click(int index) {
    if (index == state) return;

    _project(index);
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

    _project(index);
  }

  void down() {
    if (state == null) return;

    int index = state! + 4;

    if (index > slides.length - 1) {
      return;
    }

    _project(index);
  }

  void left() {
    if (state == null) return;

    int index = state! - 1;

    if (index < 0) {
      return;
    }

    _project(index);
  }

  void right() {
    if (state == null) return;

    int index = state! + 1;

    if (index > slides.length - 1) {
      return;
    }
    _project(index);
  }

  void _project(int index) {
    state = index;

    Slide slide = slides[index];

    ProjectionUtils.showSlide(slide.toJson().toString(), isLive);
  }
}
