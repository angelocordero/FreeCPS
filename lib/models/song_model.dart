import 'dart:convert';

import 'package:flutter/foundation.dart';

class Song {
  Song({
    required this.title,
    required this.lyrics,
    required this.fileName,
    required this.artist,
  });

  String artist;
  String fileName;
  Map<String, List<dynamic>> lyrics;
  String title;

  factory Song.error() {
    return Song(
      title: 'Error in loading song',
      lyrics: {},
      fileName: '',
      artist: '',
    );
  }

  factory Song.empty() {
    return Song(
      title: '',
      lyrics: {},
      fileName: '',
      artist: '',
    );
  }

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      title: map['title'] as String,
      lyrics: Map<String, List<dynamic>>.from(map['lyrics']),
      fileName: map['fileName'] as String,
      artist: map['artist'] as String,
    );
  }

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;

    return other.title == title && other.artist == artist && mapEquals(other.lyrics, lyrics) && other.fileName == fileName;
  }

  @override
  int get hashCode {
    return title.hashCode ^ artist.hashCode ^ lyrics.hashCode ^ fileName.hashCode;
  }

  @override
  String toString() {
    return 'Song(title: $title, artist: $artist, lyrics: $lyrics, fileName: $fileName)';
  }

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

  String toJson() => json.encode(toMap());
}
