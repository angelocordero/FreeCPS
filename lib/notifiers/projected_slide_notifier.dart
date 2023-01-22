import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';
import 'package:freecps/core/projection_utils.dart';

import '../models/slide_model.dart';

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

    if (index > slides.length) {
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

    if (slide.slideType == SlideType.song) {
      ProjectionUtils.showSlide(slide.text, isLive);
    } else {
      String arguments = '${slide.text}<split>${slide.reference}';
      ProjectionUtils.showSlide(arguments, isLive);
    }
  }
}
