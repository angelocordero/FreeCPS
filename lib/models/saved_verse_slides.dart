import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'scripture_reference_model.dart';
import 'slide_model.dart';
import 'verse_reference_model.dart';

/// model for verses saved in playlist
class SavedVerseSlides {
  SavedVerseSlides({
    required this.verseSlides,
    required this.scriptureRef,
  });

  ScriptureReference scriptureRef;
  List<Slide> verseSlides;

  factory SavedVerseSlides.fromJson(String source) => SavedVerseSlides.fromMap(json.decode(source) as Map<String, dynamic>);

  factory SavedVerseSlides.fromMap(Map<String, dynamic> map) {
    return SavedVerseSlides(
      verseSlides: List<ScriptureSlide>.from(
        (map['verseSlides'] as List<dynamic>).map<ScriptureSlide>(
          (x) => ScriptureSlide.fromMap(x as Map<String, dynamic>),
        ),
      ),
      scriptureRef: ScriptureReference(
        translation: map['scriptureRef']['translation'],
        translationName: map['scriptureRef']['translationName'],
        book: map['scriptureRef']['book'],
        chapter: map['scriptureRef']['chapter'],
        verse: VerseReference(verseString: map['scriptureRef']['verseReference']['verseString']),
      ),
    );
  }

  @override
  bool operator ==(covariant SavedVerseSlides other) {
    if (identical(this, other)) return true;

    return listEquals(other.verseSlides, verseSlides) && other.scriptureRef == scriptureRef;
  }

  @override
  int get hashCode => verseSlides.hashCode ^ scriptureRef.hashCode;

  @override
  String toString() => 'SavedVerseSlides(verseSlides: $verseSlides, scriptureRef: $scriptureRef)';

  SavedVerseSlides copyWith({
    List<Slide>? verseSlides,
    ScriptureReference? scriptureRef,
  }) {
    return SavedVerseSlides(
      verseSlides: verseSlides ?? this.verseSlides,
      scriptureRef: scriptureRef ?? this.scriptureRef,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'verseSlides': verseSlides.map((x) => x.toMap()).toList(),
      'scriptureRef': <String, dynamic>{
        'translation': scriptureRef.translation,
        'translationName': scriptureRef.translationName,
        'book': scriptureRef.book,
        'chapter': scriptureRef.chapter,
        'verseReference': scriptureRef.verse?.toMap(),
      },
    };
  }

  String toJson() => json.encode(toMap());
}
