import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scripture_model.dart';
import '../models/slide_model.dart';
import '../notifiers/scripture_model_notifier.dart';

import '../models/scripture_reference_model.dart';
import '../notifiers/slides_notifier.dart';

final liveProvider = StateProvider<bool>((ref) {
  return false;
});

final scriptureProvider = StateNotifierProvider<ScriptureNotifier, Scripture>((ref) {
  return ScriptureNotifier(const Scripture(
    scriptureRef: ScriptureReference(),
  ));
});

final projectorSlidesProvider = StateNotifierProvider<SlidesNotifier, List<Slide>>((ref) {
  return SlidesNotifier();
});

