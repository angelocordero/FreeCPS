import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/song_model.dart';

class MediaCenterSongsNotifier extends StateNotifier<List<Song>> {
  MediaCenterSongsNotifier(this.path) : super([]) {
    _setState();
    _listen();
  }

  String path;

  void _listen() {
    Directory(path).watch().listen((event) {
      if (!mounted) return;

      try {
        _setState();
      } catch (e) {
        //
      }
    });
  }

  void _setState() {
    state = Directory(path).listSync(recursive: false).whereType<File>().map((file) {
      return Song.fromJson(file.readAsStringSync());
    }).toList();

    state.sort((a, b) => a.title.compareTo(b.title));
  }
}
