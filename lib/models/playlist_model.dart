// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'package:freecps/models/song_model.dart';

class Playlist {
  String title;
  List<Song> songs;
  List<String> media;
  List<String> verses;

  Playlist({
    required this.title,
    required this.songs,
    required this.media,
    required this.verses,
  });

 factory Playlist.error() {
    return Playlist(title: 'Error in loading playlist', songs: [], media: [], verses: []);
  }

  factory Playlist.empty() {
    return Playlist(title: 'No playlist selected', songs: [], media: [], verses: []);
  }

  Playlist copyWith({
    String? title,
    List<Song>? songs,
    List<String>? media,
    List<String>? verses,
  }) {
    return Playlist(
      title: title ?? this.title,
      songs: songs ?? this.songs,
      media: media ?? this.media,
      verses: verses ?? this.verses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'songs': songs.map((x) => x.toMap()).toList(),
      'media': media,
      'verses': verses,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map, String songsDir) {
    List<String> songPaths = List<String>.from(map['songs']);

    return Playlist(
      title: map['title'] as String,
      songs: List<Song>.from(
        songPaths.map(
          (path) {
            return Song.fromJson(
              File(p.join(songsDir, path)).readAsStringSync(),
            );
          },
        ).toList(),
      ),
      media: List<String>.from(map['media']),
      verses: List<String>.from(map['verses']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source, String songsDir) => Playlist.fromMap(json.decode(source) as Map<String, dynamic>, songsDir);

  @override
  String toString() {
    return 'Playlist(title: $title, songs: $songs, media: $media, verses: $verses)';
  }

  @override
  bool operator ==(covariant Playlist other) {
    if (identical(this, other)) return true;

    return other.title == title && listEquals(other.songs, songs) && listEquals(other.media, media) && listEquals(other.verses, verses);
  }

  @override
  int get hashCode {
    return title.hashCode ^ songs.hashCode ^ media.hashCode ^ verses.hashCode;
  }
}
