import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Song {
  String title;
  Map<String, List<dynamic>> lyrics;

  Song({
    required this.title,
    required this.lyrics,
  });

  Song copyWith({
    String? title,
    Map<String, List<String>>? lyrics,
  }) {
    return Song(
      title: title ?? this.title,
      lyrics: lyrics ?? this.lyrics,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'lyrics': lyrics,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      title: map['title'] as String,
      lyrics: Map<String, List<dynamic>>.from(map['lyrics']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Song(title: $title, lyrics: $lyrics)';

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      mapEquals(other.lyrics, lyrics);
  }

  @override
  int get hashCode => title.hashCode ^ lyrics.hashCode;
}
