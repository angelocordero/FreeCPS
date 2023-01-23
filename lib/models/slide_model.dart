// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:freecps/core/constants.dart';

class Slide {
  String text;
  String? reference;
  SlideType slideType;

  Slide({
    required this.text,
    this.reference,
    required this.slideType,
  });


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
    };
  }

  factory Slide.fromMap(Map<String, dynamic> map) {
    return Slide(
      text: map['text'] as String,
      reference: map['reference'] != null ? map['reference'] as String : null,
      slideType: map['slideType'] as SlideType,
    );
  }

  String toJson() => json.encode(toMap());

  factory Slide.fromJson(String source) => Slide.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Slide(text: $text, reference: $reference)';

  @override
  bool operator ==(covariant Slide other) {
    if (identical(this, other)) return true;
  
    return 
      other.text == text &&
      other.reference == reference;
  }

  @override
  int get hashCode => text.hashCode ^ reference.hashCode;
}
