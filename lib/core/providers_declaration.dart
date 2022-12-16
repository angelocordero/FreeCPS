import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/bible_reference_model.dart';
import 'package:freecps/notifiers/bible_reference_notifier.dart';

final liveProvider = StateProvider<bool>((ref) {
  return false;
});

final bibleReferenceProvider = StateNotifierProvider<BibleReferenceNotifier, BibleReference>((ref) {
  try {
    String defaultBible = ref.read(availableBiblesProvider)!.first;

    return BibleReferenceNotifier(BibleReference(translation: defaultBible, book: 'Genesis', chapter: 1, verse: '1'));
  } catch (e) {
    return BibleReferenceNotifier(BibleReference());
  }
});

final availableBiblesProvider = StateProvider<List<String>?>(
  (ref) {
    List<FileSystemEntity> bibleFileEntities = Directory('bibles').listSync();

    if (bibleFileEntities.isNotEmpty) {
      List<String> temp = [];

      for (var element in bibleFileEntities) {
        temp.add(
          element.path.replaceRange(0, 7, '').trim(),
        );
      }

      return temp;
    } else {
      return null;
    }
  },
);

final selectedTranslationDataProvider = StateProvider<Map<String, dynamic>?>((ref) {
  String? selectedTranslation = ref.watch(bibleReferenceProvider).translation;

  if (selectedTranslation != null) {
    return jsonDecode(File('bibles/$selectedTranslation/$selectedTranslation.bibledata.json').readAsStringSync());
  }

  return null;
});

final versesProvider = StateProvider<List<Map>?>((ref) {
  BibleReference bibleRef = ref.watch(bibleReferenceProvider);

  if (!bibleRef.isValid) return null;

  String book = bibleRef.book!;
  String translation = bibleRef.translation!;
  int chapter = bibleRef.chapter!;

  List<Map> verses;


  // return verses from chapter
  try {
    verses = List<Map>.from(
        jsonDecode(File('bibles/$translation/books/$translation.$book.bible.json').readAsStringSync())['chapters'][chapter - 1]['verses']);
  } catch (e) {
    //if book chapters < selected chapter then return chapter 1 of book
    verses = List<Map>.from(jsonDecode(File('bibles/$translation/books/$translation.$book.bible.json').readAsStringSync())['chapters'][0]['verses']);
  }

  return verses;
});

final selectedVerseProvider = StateProvider<List<Map>?>((ref) {
  BibleReference bibleRef = ref.watch(bibleReferenceProvider);

  if (!bibleRef.isValid) return null;

  int startVerse = bibleRef.startVerse!;
  int? endVerse = bibleRef.endVerse;

  if (!bibleRef.isValid) return [];

  if (endVerse == null) {
    return [ref.watch(versesProvider)![startVerse - 1]];
  } else {
    return ref.watch(versesProvider)!.getRange(startVerse - 1, endVerse).toList();
  }
});
