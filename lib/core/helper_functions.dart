import '../models/scripture_reference_model.dart';

String scriptureRefToRefString(ScriptureReference ref) {
  return '${ref.translation} ${ref.book} ${ref.chapter}:${ref.verse!.verseString}';
}
