// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Verse {
  Verse({
    required this.text,
    required this.num,
  });

  int num;
  String text;

  factory Verse.fromJson(String source) => Verse.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      text: map['text'] as String,
      num: map['num'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'num': num,
    };
  }

  String toJson() => json.encode(toMap());
}
