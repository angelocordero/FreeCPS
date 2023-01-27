// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../core/constants.dart';

class VerseReference {
  VerseReference({
    required this.verseString,
  }) {
    List<String> num = verseString.split('-');

    if (num.length == 2) {
      verseRange = VerseRange(int.tryParse(num[0]) ?? 1, int.tryParse(num[1]));
      return;
    }

    verseRange = VerseRange(int.tryParse(num[0]) ?? 1, null);
  }

  VerseRange verseRange = const VerseRange(1, null);
  String verseString = '1';

  VerseReference.defaultVerse() {
    verseRange = const VerseRange(1, null);
  }

  factory VerseReference.fromJson(String source) => VerseReference.fromMap(json.decode(source) as Map<String, dynamic>);

  factory VerseReference.fromMap(Map<String, dynamic> map) {
    return VerseReference(
      verseString: map['verseString'] as String,
    );
  }

  @override
  bool operator ==(covariant VerseReference other) {
    if (identical(this, other)) return true;

    return other.verseString == verseString;
  }

  @override
  int get hashCode => verseString.hashCode;

  @override
  String toString() => 'VerseReference(verseString: $verseString)';

  VerseReference copyWith({
    String? verseString,
  }) {
    return VerseReference(
      verseString: verseString ?? this.verseString,
    );
  }

  String? toDisplayString() => verseString;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'verseString': verseString,
    };
  }

  String toJson() => json.encode(toMap());
}
