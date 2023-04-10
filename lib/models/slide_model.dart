// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Slide {
  Slide({
    required this.text,
  });

  String text;

  factory Slide.fromJson(String source) => Slide.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Slide.fromMap(Map<String, dynamic> map) {
    return Slide(
      text: map['text'] as String,
    );
  }

  @override
  bool operator ==(covariant Slide other) {
    if (identical(this, other)) return true;

    return other.text == text;
  }

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() => 'Slide(text: $text)';

  Slide copyWith({
    String? text,
    String? reference,
  }) {
    return Slide(
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
    };
  }

  String toJson() => json.encode(toMap());
}
