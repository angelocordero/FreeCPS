import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../models/playlist_model.dart';
import '../models/scripture_model.dart';
import '../models/scripture_reference_model.dart';
import '../models/slide_model.dart';
import '../notifiers/playlist_notifier.dart';
import '../notifiers/projected_slide_notifier.dart';
import '../notifiers/scripture_model_notifier.dart';
import '../notifiers/slides_notifier.dart';
import '../notifiers/verse_list_controller_notifier.dart';

final liveProvider = StateProvider<bool>((ref) {
  return false;
});

final ctrlKeyNotifier = StateProvider<bool>((ref) {
  return false;
});

final scriptureProvider = StateNotifierProvider<ScriptureNotifier, Scripture>((ref) {
  return ScriptureNotifier(const Scripture(
    scriptureRef: ScriptureReference(),
  ));
});

final projectionSlidesProvider = StateNotifierProvider<SlidesNotifier, List<Slide>>((ref) {
  return SlidesNotifier(ref);
});

final projectedSlideNotifier = StateNotifierProvider<ProjectedSlideNotifier, int?>((ref) {
  List<Slide> slides = ref.watch(projectionSlidesProvider);
  bool isLive = ref.watch(liveProvider);

  return ProjectedSlideNotifier(slides, isLive);
});

final verseListControllerProvider = StateNotifierProvider<VerseListControllerNotifier, ItemScrollController>((ref) {
  return VerseListControllerNotifier();
});

final activePlaylistProvider = StateNotifierProvider<PlaylistNotifier, Playlist>((ref) {
  return PlaylistNotifier();
});

final slidePanelTitleProvider = StateProvider<String>(
  (ref) {
    return '';
  },
);
