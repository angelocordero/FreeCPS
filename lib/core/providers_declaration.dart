import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/bible_reference_model.dart';
import 'package:freecps/notifiers/bible_reference_notifier.dart';

final liveProvider = StateProvider<bool>((ref) {
  return false;
});

final bibleReferenceProvider = StateNotifierProvider<BibleReferenceNotifier, BibleReference>((ref) {
  return BibleReferenceNotifier(BibleReference());
});

final selectedVersesProvider = StateProvider<List<Map>?>((ref) {
  BibleReference bibleRef = ref.watch(bibleReferenceProvider);

  List<Map>? verses = bibleRef.verses;

  if (verses == null) return null;

  if (bibleRef.endVerse != null) {
    return verses.getRange(bibleRef.startVerse! - 1, bibleRef.endVerse!).toList();
  }

  return [bibleRef.verses![bibleRef.startVerse! - 1]];
});
