import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/projector_slide_model.dart';
import 'package:freecps/models/scripture_model.dart';
import 'package:freecps/notifiers/projector_slides_notifier.dart';
import 'package:freecps/notifiers/scripture_model_notifier.dart';

final liveProvider = StateProvider<bool>((ref) {
  return false;
});

final scriptureModelProvider = StateNotifierProvider<ScriptureModelNotifier, ScriptureModel>((ref) {
  return ScriptureModelNotifier(ScriptureModel());
});

final projectorSlidesProvider = StateNotifierProvider<ProjectorSlidesNotifier, List<ProjectorSlide>>((ref) {
  return ProjectorSlidesNotifier();
});
