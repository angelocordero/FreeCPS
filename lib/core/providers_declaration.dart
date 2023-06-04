import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../models/playlist_model.dart';
import '../models/scripture_model.dart';
import '../models/slide_model.dart';
import '../notifiers/playlist_notifier.dart';
import '../notifiers/projected_slide_notifier.dart';
import '../notifiers/scripture_notifier.dart';
import '../notifiers/settings_notifier.dart';
import '../notifiers/slides_notifier.dart';
import '../notifiers/verse_list_controller_notifier.dart';
import 'constants.dart';
import 'file_utils.dart';

final liveProvider = StateProvider<bool>((ref) {
  return false;
});

final ctrlKeyNotifier = StateProvider<bool>((ref) {
  return false;
});

final scriptureProvider = StateNotifierProvider<ScriptureNotifier, Scripture>((ref) {
  return ScriptureNotifier(ref, ref.read(directoriesProvider)['biblesDir']!);
});

final slidesPanelWeightProvider = StateProvider<double>((ref) {
  return constantSlidePanelInitialWeight;
});

final projectionToSlidePanelScaleFactorProvider = StateProvider<double>((ref) {

  return 1;
});

final biblesDirectoryProvider = StateProvider<String?>((ref) {
  return null;
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
  return PlaylistNotifier(ref);
});

final slidePanelTitleProvider = StateProvider<String>((ref) {
  return '';
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, Map<String, String>>((ref) {
  String file = ref.watch(directoriesProvider)['settingsFile']!;

  return SettingsNotifier(file);
});

final directoriesProvider = StateProvider<Map<String, String>>((ref) {
  return {};
});

final initProvider = FutureProvider<bool?>((ref) async {
  bool? initialized;

  try {
    await FileUtils.initializeDirectories();

    ref.read(directoriesProvider.notifier).state = {
      'photosDir': await photosDirectory(),
      'videosDir': await videosDirectory(),
      'appDir': await appDirectory(),
      'biblesDir': await biblesDirectory(),
      'songsDir': await songsDirectory(),
      'mediaDir': await mediaDirectory(),
      'settingsDir': await settingsDir(),
      'settingsFile': await settingsFile(),
      'photoThumbnailsDir': await photoThumbnailsDirectory(),
      'playlistDir': await playlistsDirectory(),
    };

    await Future.delayed(const Duration(seconds: 1));

    initialized = true;
  } catch (e) {
    //
  }

  return initialized;
});
