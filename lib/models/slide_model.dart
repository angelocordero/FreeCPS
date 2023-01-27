// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../core/constants.dart';

class Slide {
  Slide({
    required this.text,
    this.reference,
    required this.slideType,
  });

  String? reference;
  SlideType slideType;
  String text;

  factory Slide.fromJson(String source) => Slide.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Slide.fromMap(Map<String, dynamic> map) {
    return Slide(
      text: map['text'] as String,
      slideType: SlideType.values[map['slideTypeInt'] as int],
      reference: map['reference'] != null ? map['reference'] as String : null,
    );
  }

  @override
  bool operator ==(covariant Slide other) {
    if (identical(this, other)) return true;

    return other.text == text && other.reference == reference;
  }

  @override
  int get hashCode => text.hashCode ^ reference.hashCode;

  @override
  String toString() => 'Slide(text: $text, reference: $reference)';

  Slide copyWith({
    String? text,
    String? reference,
    SlideType? slideType,
  }) {
    return Slide(
      text: text ?? this.text,
      reference: reference ?? this.reference,
      slideType: slideType ?? this.slideType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'reference': reference,
      'slideTypeInt': slideType.index,
    };
  }

  String toJson() => json.encode(toMap());
}
