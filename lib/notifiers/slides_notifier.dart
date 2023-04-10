import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/file_utils.dart';
import '../core/helper_functions.dart';
import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import '../models/saved_verse_slides.dart';
import '../models/scripture_model.dart';
import '../models/scripture_reference_model.dart';
import '../models/scripture_slide_model.dart';
import '../models/slide_model.dart';
import '../models/song_model.dart';
import '../models/song_slide_model.dart';
import '../models/verse_model.dart';

/// Notifier that holds all the generated slides in the Slides Panel
class SlidesNotifier extends StateNotifier<List<Slide>> {
  SlidesNotifier(this._ref) : super([]);

  // need ref to change the slides panel title
  final StateNotifierProviderRef<SlidesNotifier, List<Slide>> _ref;

  ScriptureReference? _scriptureReference;

  generateSongSlide({required Song song}) {
    List<Slide> temp = [];

    for (var entries in song.lyrics.entries) {
      String sectionLabel = entries.key;

      for (var element in entries.value) {
        temp.add(SongSlide(text: element, reference: sectionLabel));
      }
    }

    state = List<Slide>.from(temp);
    _setSlidesPanelTitle(song.title);
    _scriptureReference = null;
  }

  generateSavedVerseSlides(SavedVerseSlides slides) {
    state = slides.verseSlides;

    _setSlidesPanelTitle(scriptureRefToString(slides.scriptureRef));
  }

  generateScriptureSlides({
    required Scripture scripture,
  }) {
    int startVerse = scripture.scriptureRef.verse!.verseRange.item1;
    int? endVerse = scripture.scriptureRef.verse!.verseRange.item2;

    _scriptureReference = scripture.scriptureRef;
    _setSlidesPanelTitle(scriptureRefToString(scripture.scriptureRef));

    if (endVerse == null) {
      _setSingleVerseScriptureSlide(scripture, startVerse);
      return;
    }

    _setMultipleVerseScriptureSlides(scripture, startVerse, endVerse);
  }

  void saveScriptureSlideToPlaylist(Playlist playlist) {
    if (_scriptureReference == null) return;

    SavedVerseSlides savedVerseSlides = SavedVerseSlides(verseSlides: state, scriptureRef: _scriptureReference!);

    List<SavedVerseSlides> playlistVerses = [...playlist.verses, savedVerseSlides];

    FileUtils.savePlaylist(playlist.copyWith(verses: playlistVerses));
  }

  bool _breakOnNewVerse() {
    return _ref.read(settingsProvider.select((value) => value['break_on_new_verse'])) == 'true' ? true : false;
  }

  void _setMultipleVerseScriptureSlides(Scripture scripture, int startVerse, int endVerse) {
    if (!_breakOnNewVerse()) {
      _stitchVerses(scripture, startVerse, endVerse);
      return;
    }

    List<Slide> temp = [];

    scripture.verses!.getRange(startVerse - 1, endVerse).forEach(
      (verse) {
        String text = _getTextWithSuperscript(verse.num, verse.text);
        int maxChars = maxCharacters(text, songSlideTextStyle);

        if (text.length > maxChars) {
          _splitSlides(text, maxChars, scripture);
          temp.addAll(_splitSlides(text, maxChars, scripture));
        } else {
          temp.add(
            ScriptureSlide(
              text: text,
              reference: scriptureRefToString(scripture.scriptureRef),
            ),
          );
        }
      },
    );

    state = temp;
  }

  void _setSingleVerseScriptureSlide(Scripture scripture, int startVerse) {
    Verse verse = scripture.verses![startVerse - 1];
    String text = _getTextWithSuperscript(verse.num, verse.text).trim();
    int maxChars = maxCharacters(text, songSlideTextStyle);

    if (text.length > maxChars) {
      state = _splitSlides(text, maxChars, scripture);
    } else {
      state = [
        ScriptureSlide(
          text: text,
          reference: scriptureRefToString(scripture.scriptureRef),
        ),
      ];
    }
  }

  List<Slide> _splitSlides(String text, int maxChars, Scripture scripture) {
    int slideCount = text.length ~/ maxChars;

    int charsPerSlide = text.length ~/ slideCount;

    // split verse into slide count

    List<Slide> temp = [];

    int offset = 0;
    for (var i = 0; i < slideCount; i++) {
      int start = (i * charsPerSlide) - offset;
      int end = start + charsPerSlide;

      while (text[end - 1] != ' ') {
        end--;
        offset++;
      }

      if (i == slideCount - 1) end = text.length;

      String slideText = text.substring(start, end);

      temp.add(
        ScriptureSlide(
          text: slideText,
          reference: scriptureRefToString(scripture.scriptureRef),
        ),
      );
    }

    return temp;
  }

  String _getTextWithSuperscript(int number, String text) {
    List<String> digits = number.toString().characters.map((element) {
      int digit = int.parse(element);

      return superscriptMap[digit];
    }).toList();

    if (digits.length == 1) {
      return '${digits[0]} $text';
    } else if (digits.length == 2) {
      return '${digits[0]}${digits[1]} $text';
    } else {
      return '${digits[0]}${digits[1]}${digits[2]} $text';
    }
  }

  void _setSlidesPanelTitle(String title) {
    _ref.read(slidePanelTitleProvider.notifier).state = title;
  }

  void _stitchVerses(Scripture scripture, int startVerse, int endVerse) {
    String passage = '';

    scripture.verses!.getRange(startVerse - 1, endVerse).forEach((verse) {
      String text = _getTextWithSuperscript(verse.num, verse.text);
      passage = '$passage $text';
    });

    int maxChars = maxCharacters(passage, songSlideTextStyle);

    if (passage.length > maxChars) {
      state = _splitSlides(passage, maxChars, scripture);
    } else {
      state = [
        ScriptureSlide(
          text: passage,
          reference: scriptureRefToString(scripture.scriptureRef),
        ),
      ];
    }
  }
}
