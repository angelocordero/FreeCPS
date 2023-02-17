import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/song_model.dart';

class MediaCenterSongsNotifier extends StateNotifier<List<Song>> {
  MediaCenterSongsNotifier(this._path) : super([]) {
    _setState();
    _listen();
  }

  final String _path;

  List<Song> _songs = [];

  void _listen() {
    Directory(_path).watch().listen((event) {
      if (!mounted) return;

      try {
        _setState();
      } catch (e) {
        //
      }
    });
  }

  void _setState() {
    _songs = Directory(_path).listSync(recursive: false).whereType<File>().map((file) {
      return Song.fromJson(file.readAsStringSync());
    }).toList();

    _songs.sort((a, b) => a.title.compareTo(b.title));

    state = _songs;
  }

  void search(String query) {
    state = _songs.where((element) => element.title.toLowerCase().startsWith(query)).toList();
  }

  void clearSearch() {
    state = _songs;
  }
}
