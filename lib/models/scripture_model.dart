import 'package:freezed_annotation/freezed_annotation.dart';

import 'scripture_reference_model.dart';
import 'verse_model.dart';

part 'scripture_model.freezed.dart';

@freezed
class Scripture with _$Scripture {
  const factory Scripture({
    required ScriptureReference scriptureRef,
    List<Verse>? verses,
  }) = _Scripture;
}
