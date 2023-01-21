import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';
import 'package:freecps/models/scripture_model.dart';
import 'package:freecps/models/scripture_reference_model.dart';

import '../models/slide_model.dart';
import '../models/song_model.dart';
import '../models/verse_model.dart';

/// Notifier that holds all the generated slides in the Slides Panel
class SlidesNotifier extends StateNotifier<List<Slide>> {
  SlidesNotifier() : super([]);

  generateSongSlide({required Song song}) {
    List<Slide> temp = [];

    for (var entries in song.lyrics.entries) {
      String ref = entries.key;

      for (var element in entries.value) {
        temp.add(Slide(text: element, reference: ref, slideType: SlideType.song));
      }
    }

    state = List<Slide>.from(temp);
  }

  generateScriptureSlides({
    required Scripture scripture,
  }) {
    int startVerse = scripture.scriptureRef.verse!.verseRange.item1;
    int? endVerse = scripture.scriptureRef.verse!.verseRange.item2;

    if (endVerse != null) {
      _setMultipleScriptureSlides(scripture, startVerse, endVerse);
      return;
    }

    _setSingleScriptureSlide(scripture, startVerse);
  }

  void _setMultipleScriptureSlides(Scripture scripture, int startVerse, int endVerse) {
    state = scripture.verses!
        .getRange(
      startVerse - 1,
      endVerse,
    )
        .map(
      (verse) {
        List<String> superScriptDigits = _getSuperscript(verse.num);

        String text = '';

        if (superScriptDigits.length == 1) {
          text = '${superScriptDigits[0]} ${verse.text}';
        } else if (superScriptDigits.length == 2) {
          text = '${superScriptDigits[0]}${superScriptDigits[1]} ${verse.text}';
        } else {
          text = '${superScriptDigits[0]}${superScriptDigits[1]}${superScriptDigits[2]} ${verse.text}';
        }

        return Slide(
          text: text,
          reference: _scriptureRefToString(scripture.scriptureRef),
          slideType: SlideType.scripture,
        );
      },
    ).toList();
  }

  void _setSingleScriptureSlide(Scripture scripture, int startVerse) {
    Verse verse = scripture.verses![startVerse - 1];

    List<String> superScriptDigits = _getSuperscript(verse.num);

    String text = '';

    if (superScriptDigits.length == 1) {
      text = '${superScriptDigits[0]} ${verse.text}';
    } else if (superScriptDigits.length == 2) {
      text = '${superScriptDigits[0]}${superScriptDigits[1]} ${verse.text}';
    } else {
      text = '${superScriptDigits[0]}${superScriptDigits[1]}${superScriptDigits[2]} ${verse.text}';
    }

    state = [
      Slide(
        text: text,
        reference: _scriptureRefToString(scripture.scriptureRef),
        slideType: SlideType.scripture,
      ),
    ];
  }

  List<String> _getSuperscript(int num) {
    return num.toString().characters.map((element) {
      int digit = int.parse(element);

      return superscriptMap[digit];
    }).toList();
  }

  String _scriptureRefToString(ScriptureReference ref) {
    return '${ref.translation} ${ref.book} ${ref.chapter}:${ref.verse!.verseString}';
  }
}
