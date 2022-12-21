import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/scripture_model.dart';

import '../models/slide_model.dart';

/// Notifier that holds all the generated slides in the Slides Panel
class SlidesNotifier extends StateNotifier<List<Slide>> {
  SlidesNotifier() : super([]);

  //TODO needs to be redone

  generateScriptureSlides({
    required Scripture scripture,
  }) {
    int startVerse = scripture.scriptureRef.verse!.verseRange.item1;
    int? endVerse = scripture.scriptureRef.verse!.verseRange.item2;


    if (endVerse != null) {
      state = scripture.verses!
          .getRange(
        startVerse - 1,
        endVerse,
      )
          .map(
        (verse) {
          return Slide(
            text: verse.text,
            reference: scripture.scriptureRef.toString(),
          );
        },
      ).toList();
      return;
    }

    state = [
      Slide(
        text: scripture.verses![startVerse - 1].text,
        reference: scripture.scriptureRef.toString(),
      ),
    ];
  }
}