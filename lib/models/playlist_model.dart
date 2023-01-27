// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'package:freecps/models/saved_verse_slides.dart';
import 'package:freecps/models/song_model.dart';

class Playlist {
  String title;
  String fileName;
  List<Song> songs;
  List<String> media;
  List<SavedVerseSlides> verses;

  Playlist({
    required this.title,
    required this.fileName,
    required this.songs,
    required this.media,
    required this.verses,
  });

  factory Playlist.error() {
    return Playlist(title: 'Error in loading playlist', songs: [], media: [], verses: [], fileName: '');
  }

  factory Playlist.empty() {
    return Playlist(title: 'No playlist selected', songs: [], media: [], verses: [], fileName: '');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'songs': songs.map((x) => x.fileName).toList(),
      'media': media,
      'verses': verses.map((x) => x.toMap()).toList(),
      'fileName': fileName,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map, String songsDir) {
    List<String> fileNames = List<String>.from(map['songs']);

    return Playlist(
      title: map['title'] as String,
      songs: List<Song>.from(
        fileNames.map(
          (fileName) {
            try {
              return Song.fromJson(
                File(p.join(songsDir, fileName)).readAsStringSync(),
              );
            } catch (e) {
              return Song.error();
            }
          },
        ).toList(),
      ),
      media: List<String>.from(map['media']),
      verses: ((map['verses']) as List).map((e) => SavedVerseSlides.fromMap(e)).toList(),
      fileName: map['fileName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source, String songsDir) => Playlist.fromMap(json.decode(source) as Map<String, dynamic>, songsDir);

  Playlist copyWith({
    String? title,
    String? fileName,
    List<Song>? songs,
    List<String>? media,
    List<SavedVerseSlides>? verses,
  }) {
    return Playlist(
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      songs: songs ?? this.songs,
      media: media ?? this.media,
      verses: verses ?? this.verses,
    );
  }

  @override
  String toString() {
    return 'Playlist(title: $title, fileName: $fileName, songs: $songs, media: $media, verses: $verses)';
  }

  @override
  bool operator ==(covariant Playlist other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.fileName == fileName &&
        listEquals(other.songs, songs) &&
        listEquals(other.media, media) &&
        listEquals(other.verses, verses);
  }

  @override
  int get hashCode {
    return title.hashCode ^ fileName.hashCode ^ songs.hashCode ^ media.hashCode ^ verses.hashCode;
  }
}
