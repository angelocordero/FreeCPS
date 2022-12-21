
import 'package:freecps/models/scripture_reference_model.dart';
import 'package:freecps/models/verse_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scripture_model.freezed.dart';

@freezed
class Scripture with _$Scripture {
  const factory Scripture({
     required ScriptureReference scriptureRef,
      List<Verse>? verses,

  }) = _Scripture;
}

