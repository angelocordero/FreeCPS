import 'package:freecps/models/verse_reference_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scripture_reference_model.freezed.dart';

@freezed
class ScriptureReference with _$ScriptureReference {
  const factory ScriptureReference({
     String? translation,
     String? translationName,
     String? book,
     int? chapter,
     VerseReference? verse,

  }) = _ScriptureReference;
}
