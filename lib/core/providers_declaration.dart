import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/scripture_model.dart';
import 'package:freecps/notifiers/bible_reference_notifier.dart';

final liveProvider = StateProvider<bool>((ref) {
  return false;
});

final ScriptureModelProvider = StateNotifierProvider<ScriptureModelNotifier, ScriptureModel>((ref) {
  return ScriptureModelNotifier(ScriptureModel());
});
