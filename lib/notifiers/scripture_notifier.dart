import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';
import 'package:path/path.dart';

import '../models/scripture_model.dart';
import '../models/scripture_reference_model.dart';
import '../models/verse_model.dart';
import '../models/verse_reference_model.dart';

/// Notifier that holds all data of the selected scripture
class ScriptureNotifier extends StateNotifier<Scripture> {
  ScriptureNotifier(this.ref) : super(const Scripture(scriptureRef: ScriptureReference())) {
    _init();
  }

  StateNotifierProviderRef<ScriptureNotifier, Scripture> ref;

  String _biblesDirectory = '';
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
      state = state.copyWith.scriptureRef(verse: VerseReference.defaultVerse());
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
      state = state.copyWith.scriptureRef(verse: VerseReference.defaultVerse());
    }

    _setVerses();
    _setVerseMax();
  }

  set chapterRef(int? chapter) {
    if (state.scriptureRef.chapter == chapter) return;

    state = state.copyWith.scriptureRef(chapter: chapter);
    _setChapterMax();

    if (state.scriptureRef.verse == null && _bookData != null) {
      state = state.copyWith.scriptureRef(verse: VerseReference.defaultVerse());
    }

    _setVerses();
    _setVerseMax();
  }

  set verseRef(String? verse) {
    state = state.copyWith.scriptureRef(verse: VerseReference(verseString: verse!));
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

  void _init() async {
    _biblesDirectory = await biblesDirectory();

    _setAvailableBibles();
  }

  void _setAvailableBibles() {
    _availableBibles.clear();

    List<FileSystemEntity> bibleFileEntities = Directory(_biblesDirectory).listSync();

    if (bibleFileEntities.isNotEmpty) {
      for (var element in bibleFileEntities) {
        _availableBibles.add(
          basenameWithoutExtension(element.path),
        );
      }
    }

    if (_availableBibles.isNotEmpty) {
      translationRef = _availableBibles.first;
    }

    File(_biblesDirectory).watch().listen((event) {
      _availableBibles.clear();

      List<FileSystemEntity> bibleFileEntities = Directory(_biblesDirectory).listSync().whereType<Directory>().toList();

      if (bibleFileEntities.isNotEmpty) {
        for (var element in bibleFileEntities) {
          _availableBibles.add(
            basenameWithoutExtension(element.path),
          );
        }

        translationRef = _availableBibles.first;
      }
    });
  }

  void _setTranslationData() {
    if (state.scriptureRef.translation == null) return;

    String path = '$_biblesDirectory/${state.scriptureRef.translation}/${state.scriptureRef.translation}.metadata.json';

    _translationData = jsonDecode(File(path).readAsStringSync());

    if (_translationData == null) return;

    state = state.copyWith.scriptureRef(translationName: _translationData!['translationName']);
  }

  void _setBookData() {
    if (state.scriptureRef.translation == null) return;

    String book = state.scriptureRef.book != null ? state.scriptureRef.book.toString() : _books!.first;

    String bookPath = '$_biblesDirectory/${state.scriptureRef.translation}/books/${state.scriptureRef.translation}.$book.json';

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
      state = state.copyWith.scriptureRef(verse: VerseReference.defaultVerse());
    }

    //! untested

    //List<int?> verseList = Utils.verseListFromVerseString(state.scriptureRef.verse);

    if (state.scriptureRef.verse!.verseRange.item1 >= _verseMax!) {
      verseRef = _verseMax.toString();
      return;
    }

    if (state.scriptureRef.verse!.verseRange.item2 == null) return;

    if (state.scriptureRef.verse!.verseRange.item1 > _verseMax!) {
      verseRef = '${state.scriptureRef.verse!.verseRange.item1}-$_verseMax';
      return;
    }

    //! untested
  }
}
