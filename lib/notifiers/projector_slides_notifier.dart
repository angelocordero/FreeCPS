import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/bible_reference_model.dart';
import 'package:freecps/models/projector_slide_model.dart';

/// Notifier that holds all the generated slides in the Slides Panel
class ProjectorSlidesNotifier extends StateNotifier<List<ProjectorSlide>> {
  ProjectorSlidesNotifier() : super([]);

  generateScripture({
    required List<Map> verses,
    required BibleReference bibleRef,
    required int startVerse,
    int? endVerse,
  }) {
    if (endVerse != null) {
      print('here');
      state = verses
          .getRange(
        startVerse - 1,
        endVerse,
      )
          .map(
        (verse) {
          return ProjectorSlide.scripture(
            text: verse['text'],
            bibleRef: bibleRef,
          );
        },
      ).toList();
      print(state);
      return;
    }

    state = [
      ProjectorSlide.scripture(
        text: verses[startVerse - 1]['text'],
        bibleRef: bibleRef,
      ),
    ];
  }
}
