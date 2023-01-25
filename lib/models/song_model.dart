import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Song {
  String title;
  String artist;
  Map<String, List<dynamic>> lyrics;
  String fileName;

  Song({
    required this.title,
    required this.lyrics,
    required this.fileName,
    required this.artist,
  });

  Song copyWith({
    String? title,
    Map<String, List<dynamic>>? lyrics,
    String? fileName,
    String? artist,
  }) {
    return Song(
      title: title ?? this.title,
      lyrics: lyrics ?? this.lyrics,
      fileName: fileName ?? this.fileName,
      artist: artist ?? this.artist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'lyrics': lyrics,
      'fileName': fileName,
      'artist': artist,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      title: map['title'] as String,
      lyrics: Map<String, List<dynamic>>.from(map['lyrics']),
      fileName: map['fileName'] as String,
      artist: map['artist'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Song(title: $title, artist: $artist, lyrics: $lyrics, fileName: $fileName)';
  }

  @override
  int get hashCode {
    return title.hashCode ^
      artist.hashCode ^
      lyrics.hashCode ^
      fileName.hashCode;
  }

  

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.artist == artist &&
      mapEquals(other.lyrics, lyrics) &&
      other.fileName == fileName;
  }
}
