import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/scripture_model.dart';
import 'package:freecps/models/projector_slide_model.dart';

import '../core/utils.dart';

/// Notifier that holds all the generated slides in the Slides Panel
class ProjectorSlidesNotifier extends StateNotifier<List<ProjectorSlide>> {
  ProjectorSlidesNotifier() : super([]);

  generateScriptureSlides({
    required Scripture scripture,
  }) {
    List<int?> verseRefList = Utils.verseListFromVerseString(scripture.scriptureRef.verse);

    if (verseRefList[1] != null) {
      state = scripture.verses!
          .getRange(
        verseRefList[0]! - 1,
        verseRefList[1]!,
      )
          .map(
        (verse) {
          return ProjectorSlide.scripture(
            text: verse.text,
            bibleRef: scripture.scriptureRef,
          );
        },
      ).toList();
      return;
    }

    state = [
      ProjectorSlide.scripture(
        text: scripture.verses![verseRefList[0]! - 1].text,
        bibleRef: scripture.scriptureRef,
      ),
    ];
  }
}
