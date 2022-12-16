import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/bible_reference_model.dart';
import 'package:freecps/notifiers/bible_reference_notifier.dart';

final liveProvider = StateProvider<bool>((ref) {
  return false;
});

final bibleReferenceProvider = StateNotifierProvider<BibleReferenceNotifier, BibleReference>((ref) {
    return BibleReferenceNotifier(BibleReference());
});
