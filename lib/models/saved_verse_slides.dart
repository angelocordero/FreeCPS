// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freecps/models/verse_reference_model.dart';

import 'scripture_reference_model.dart';
import 'slide_model.dart';

/// model for verses saved in playlist
class SavedVerseSlides {
  List<Slide> verseSlides;
  ScriptureReference scriptureRef;
  SavedVerseSlides({
    required this.verseSlides,
    required this.scriptureRef,
  });

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

  factory SavedVerseSlides.fromMap(Map<String, dynamic> map) {
    return SavedVerseSlides(
      verseSlides: List<Slide>.from(
        (map['verseSlides'] as List<dynamic>).map<Slide>(
          (x) => Slide.fromMap(x as Map<String, dynamic>),
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

  String toJson() => json.encode(toMap());

  factory SavedVerseSlides.fromJson(String source) => SavedVerseSlides.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SavedVerseSlides(verseSlides: $verseSlides, scriptureRef: $scriptureRef)';

  @override
  bool operator ==(covariant SavedVerseSlides other) {
    if (identical(this, other)) return true;

    return listEquals(other.verseSlides, verseSlides) && other.scriptureRef == scriptureRef;
  }

  @override
  int get hashCode => verseSlides.hashCode ^ scriptureRef.hashCode;
}
