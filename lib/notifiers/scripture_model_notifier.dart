import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/utils.dart';
import 'package:freecps/models/scripture_model.dart';

import '../models/verse_model.dart';

/// Notifier that holds all data of the selected scripture
class ScriptureNotifier extends StateNotifier<Scripture> {
  ScriptureNotifier(Scripture scripture) : super(scripture) {
    _init();
  }

  final Set<String> _availableBibles = <String>{};
  List<Map<String, dynamic>>? _bookData;
  Set<String>? _books;
  int? _chapterMax;

  Map<String, dynamic>? _translationData;
  int? _verseMax;

  set translationRef(String? translation) {
    if (state.scriptureRef.translation == translation) return;

    state = state.copyWith.scriptureRef(translation: translation);
    _setTranslationData();
    _setBooks();

    if (state.scriptureRef.book == null && _books != null) {
      state = state.copyWith.scriptureRef(book: _books!.first);
    }
    _setBookData();

    if (state.scriptureRef.chapter == null) {
      state = state.copyWith.scriptureRef(chapter: 1);
    }

    _setChapterMax();

    if (state.scriptureRef.verse == null && _bookData != null) {
      state = state.copyWith.scriptureRef(verse: '1');
    }
    _setVerses();
    _setVerseMax();
  }

  set bookRef(String? book) {
    if (state.scriptureRef.translation == null) return;

    if (book != null && book.isEmpty) {
      book = 'Genesis';
    }

    state = state.copyWith.scriptureRef(book: book);

    _setBookData();

    if (state.scriptureRef.chapter == null) {
      state = state.copyWith.scriptureRef(chapter: 1);
    }

    _setChapterMax();

    if (state.scriptureRef.verse == null && _bookData != null) {
      state = state.copyWith.scriptureRef(verse: '1');
    }

    _setVerses();
    _setVerseMax();

    //set state to rebuild listener widgets
    state = state;
  }

  set chapterRef(int? chapter) {
    if (state.scriptureRef.chapter == chapter) return;

    state = state.copyWith.scriptureRef(chapter: chapter);
    _setChapterMax();

    if (state.scriptureRef.verse == null && _bookData != null) {
      state = state.copyWith.scriptureRef(verse: '1');
    }

    _setVerses();
    _setVerseMax();

    //set state to rebuild listener widgets
    state = state;
  }

  set verseRef(String? verse) {
    state = state.copyWith.scriptureRef(verse: verse);
  }

  Set<String>? get getAvailableBibles {
    return _availableBibles;
  }

  Set<String> get getBooks {
    return _books ?? {};
  }

  int get getChapterMax {
    return _chapterMax ?? 0;
  }

  int get getVerseMax {
    return _verseMax ?? 0;
  }

  List<Verse> get getVerses {
    return state.verses ?? [];
  }

  void _init() {
    _setAvailableBibles();

    if (_availableBibles.isNotEmpty) {
      translationRef = _availableBibles.first;
    }
  }

  void _setAvailableBibles() {
    _availableBibles.clear();

    List<FileSystemEntity> bibleFileEntities = Directory('bibles').listSync();

    if (bibleFileEntities.isNotEmpty) {
      for (var element in bibleFileEntities) {
        _availableBibles.add(
          element.path.replaceRange(0, 7, '').trim(),
        );
      }
    }
  }

  void _setTranslationData() {
    if (state.scriptureRef.translation == null) return;
    _translationData =
        jsonDecode(File('bibles/${state.scriptureRef.translation}/${state.scriptureRef.translation}.bibledata.json').readAsStringSync());
  }

  void _setBookData() {
    if (state.scriptureRef.translation == null) return;
    String bookPath = 'bibles/${state.scriptureRef.translation}/books/${state.scriptureRef.translation}.${state.scriptureRef.book}.bible.json';

    _bookData = List<Map<String, dynamic>>.from(jsonDecode(File(bookPath).readAsStringSync())['chapters']);
  }

  /// lists books from a given translation
  void _setBooks() {
    if (_translationData == null) return;
    _books = Map<String, int>.from(_translationData!['books']).keys.toSet();
  }

  /// lists chapters from a given book in a translation
  void _setChapterMax() {
    if (_translationData == null || state.scriptureRef.book == null) return;

    _chapterMax = _translationData!['books'][state.scriptureRef.book];
    if (state.scriptureRef.chapter! > _chapterMax!) {
      state = state.copyWith.scriptureRef(chapter: _chapterMax);
    }
  }

  /// lists verses from a chapter in a book in a translation
  void _setVerses() {
    if (_bookData == null || state.scriptureRef.chapter == null || _chapterMax == null) return;

    try {
      state = state.copyWith(
        verses: List<Map>.from(_bookData![state.scriptureRef.chapter! - 1]['verses']).map((element) {
          return Verse(text: element['text'], num: element['num']);
        }).toList(),
      );
    } catch (e) {
      //
    }
  }

  void _setVerseMax() {
    if (state.verses == null) return;

    _verseMax = state.verses!.length;

    // fix this
    //set initial verse to 1
    if (_bookData != null && state.scriptureRef.verse == null) {
      state = state.copyWith.scriptureRef(verse: '1');
    }

    //! untested

    List<int?> verseList = Utils.verseListFromVerseString(state.scriptureRef.verse);

    if (verseList[0]! >= _verseMax!) {
      verseRef = _verseMax.toString();
      return;
    }

    if (verseList[1] == null) return;

    if (verseList[1]! > _verseMax!) {
      verseRef = '${verseList[0]!}-$_verseMax';
      return;
    }

    //! untested
  }

  // List<Map>? get selectedVerses {
  //   if (state.verses == null || state.verse == null) return null;

  //   if (state.endVerse != null) {
  //     return state.verses!.getRange(state.startVerse! - 1, state.endVerse!).toList();
  //   }

  //   return [state.verses![state.startVerse! - 1]];
  // }
}