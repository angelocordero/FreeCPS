import 'dart:convert';

import 'package:freecps/models/slide_model.dart';

class SongSlide extends Slide {
  SongSlide({required super.text, this.reference});

  String? reference;

   factory SongSlide.fromJson(String source) => SongSlide.fromMap(json.decode(source) as Map<String, dynamic>);

  factory SongSlide.fromMap(Map<String, dynamic> map) {
    return SongSlide(
      text: map['text'] as String,
      reference: map['reference'] as String,
    );
  }



@override
  bool operator ==(covariant SongSlide other) {
    if (identical(this, other)) return true;

    return other.text == text && other.reference == reference;
  }

  @override
  int get hashCode {
  return text.hashCode ^ reference.hashCode;
    
  } 

  @override
  String toString() => 'ScriptureSlide(text: $text, reference: $reference)';

  @override
  SongSlide copyWith({
    String? text,
    String? reference,
  }) {
    return SongSlide(
      text: text ?? this.text,
      reference: reference ?? this.reference
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'reference': reference,
    };
  }

  @override
  String toJson() => json.encode(toMap());
}
