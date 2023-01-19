import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/notifiers/playlist_notifier.dart';
import 'package:freecps/notifiers/slide_index_notifier.dart';
import 'package:freecps/notifiers/verse_list_controller_notifier.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/playlist_model.dart';
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

final slideIndexProvider = StateNotifierProvider<SlideIndexNotifier, int?>((ref) {
  ref.watch(projectorSlidesProvider);

  return SlideIndexNotifier();
});

final verseListKeyboardNotifier = StateProvider<bool>((ref) {
  return false;
});

final verseListControllerProvider = StateNotifierProvider<VerseListControllerNotifier, ItemScrollController>((ref) {
  return VerseListControllerNotifier();
});

final playlistProvider = StateNotifierProvider<PlaylistNotifier, Playlist>((ref){
  return PlaylistNotifier();
});
