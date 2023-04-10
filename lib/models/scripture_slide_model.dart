import 'dart:convert';

import 'slide_model.dart';

class ScriptureSlide extends Slide {
  ScriptureSlide({required super.text, this.reference});

  String? reference;

  factory ScriptureSlide.fromJson(String source) => ScriptureSlide.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ScriptureSlide.fromMap(Map<String, dynamic> map) {
    return ScriptureSlide(
      text: map['text'] as String,
      reference: map['reference'] as String,
    );
  }



@override
  bool operator ==(covariant ScriptureSlide other) {
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
  ScriptureSlide copyWith({
    String? text,
    String? reference,
  }) {
    return ScriptureSlide(
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
