import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/bible_reference_model.dart';

class BibleReferenceNotifier extends StateNotifier<BibleReference> {
  BibleReferenceNotifier(BibleReference bibleRef) : super(bibleRef) {
    _init();
  }

  final Set<String> _availableBibles = <String>{};
  List<Map<String, dynamic>>? _bookData;
  Set<String>? _books;
  int? _chapterMax;

  Map<String, dynamic>? _translationData;
  int? _verseMax;

  set translationRef(String? translation) {
    if (state.translation == translation) return;

    state = state.copyWith(translation: translation);
    _setTranslationData();
    _setBooks();

    if (state.book == null && _books != null) {
      state.book = _books!.first;
    }
    _setBookData();

    state.chapter ??= 1;

    _setChapterMax();

    if (state.verse == null && _bookData != null) {
      state.verse = '1';
    }
    _setVerses();
    _setVerseMax();

    //set state to rebuild listener widgets
    state = state;
  }

  set bookRef(String? book) {
    if (state.translation == null) return;

    if (book != null && book.isEmpty) {
      book = 'Genesis';
    }

    // state = state.copyWith(book: book);
    state.book = book;

    _setBookData();

    state.chapter ??= 1;

    _setChapterMax();

    if (state.verse == null && _bookData != null) {
      //state = state.copyWith(verse: '1');

      state.verse = '1';
    }

    _setVerses();
    _setVerseMax();

    //set state to rebuild listener widgets
    state = state;
  }

  set chapterRef(int? chapter) {
    if (state.chapter == chapter) return;

    state.chapter = chapter;
    _setChapterMax();

    if (state.verse == null && _bookData != null) {
      state.verse = '1';
    }

    _setVerses();
    _setVerseMax();

    //set state to rebuild listener widgets
    state = state;
  }

  set verseRef(String? verse) {
    state = state.copyWith(verse: verse);
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

  List<Map> get getVerses {
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
    if (state.translation == null) return;
    _translationData = jsonDecode(File('bibles/${state.translation}/${state.translation}.bibledata.json').readAsStringSync());
  }

  void _setBookData() {
    if (state.translation == null) return;
    String bookPath = 'bibles/${state.translation}/books/${state.translation}.${state.book}.bible.json';

    _bookData = List<Map<String, dynamic>>.from(jsonDecode(File(bookPath).readAsStringSync())['chapters']);
  }

  /// lists books from a given translation
  void _setBooks() {
    if (_translationData == null) return;
    _books = Map<String, int>.from(_translationData!['books']).keys.toSet();
  }

  /// lists chapters from a given book in a translation
  void _setChapterMax() {
    if (_translationData == null || state.book == null) return;

    _chapterMax = _translationData!['books'][state.book];
    if (state.chapter! > _chapterMax!) {
      state = state.copyWith(chapter: _chapterMax);
    }
  }

  /// lists verses from a chapter in a book in a translation
  void _setVerses() {
    if (_bookData == null || state.chapter == null || _chapterMax == null) return;

    try {
      state = state.copyWith(verses: List<Map<dynamic, dynamic>>.from(_bookData![state.chapter! - 1]['verses']));
    } catch (e) {
      //
    }
  }

  void _setVerseMax() {
    if (state.verses == null) return;

    _verseMax = state.verses!.length;

    // fix this
    //set initial verse to 1
    if (_bookData != null && state.verse == null) {
      state = state.copyWith(verse: '1');
    }

    //! untested

    if (state.startVerse! >= _verseMax!) {
      verseRef = _verseMax.toString();
      return;
    }

    if (state.endVerse == null) return;

    if (state.endVerse! > _verseMax!) {
      verseRef = '${state.startVerse}-$_verseMax';
      return;
    }

    //! untested
  }
}
