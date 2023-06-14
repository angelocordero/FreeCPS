// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


sealed class Slide {
  Slide({
    required this.text,
    this.reference,
  });

  String text;
  String? reference;

  @override
  bool operator ==(covariant Slide other) {
    if (identical(this, other)) return true;

    return other.text == text && other.reference == reference;
  }

  @override
  int get hashCode => text.hashCode ^ reference.hashCode;

  @override
  String toString() => 'Slide(text: $text, reference: $reference)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'reference': reference,
    };
  }

  String toJson() => json.encode(toMap());
}

class ScriptureSlide extends Slide {
  ScriptureSlide({required super.text, super.reference});

  factory ScriptureSlide.fromJson(String source) => ScriptureSlide.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ScriptureSlide.fromMap(Map<String, dynamic> map) {
    return ScriptureSlide(
      text: map['text'] as String,
      reference: map['reference'] as String,
    );
  }


  ScriptureSlide copyWith({
    String? text,
    String? reference,
  }) {
    return ScriptureSlide(text: text ?? this.text, reference: reference ?? this.reference);
  }
}

class SongSlide extends Slide {
  SongSlide({required super.text, super.reference});

  factory SongSlide.fromJson(String source) => SongSlide.fromMap(json.decode(source) as Map<String, dynamic>);

  factory SongSlide.fromMap(Map<String, dynamic> map) {
    return SongSlide(
      text: map['text'] as String,
      reference: map['reference'] as String,
    );
  }


  SongSlide copyWith({
    String? text,
    String? reference,
  }) {
    return SongSlide(text: text ?? this.text, reference: reference ?? this.reference);
  }
}
