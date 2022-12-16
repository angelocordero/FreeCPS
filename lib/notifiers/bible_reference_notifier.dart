import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/bible_reference_model.dart';

class BibleReferenceNotifier extends StateNotifier<BibleReference> {
  BibleReferenceNotifier(BibleReference ref) : super(ref);

  void updateVerse(String verse) {
    try {
      state = state.copyWith(verse: verse);
    } catch (e) {
//
    }
  }

  void updateChapter(int chapter) {
    try {
      state = state.copyWith(chapter: chapter);
    } catch (e) {
      //
    }
  }

  void updateBook(String book) {
    try {
      state = state.copyWith(book: book);
    } catch (e) {
      //
    }
  }

  void updateTranslation({required String translation}) {
    try {
      state = state.copyWith(translation: translation);
    } catch (e) {
      //
    }
  }
}
