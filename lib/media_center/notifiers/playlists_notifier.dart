import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/playlist_model.dart';

class PlaylistsNotifier extends StateNotifier<List<Playlist>> {
  PlaylistsNotifier(this.playlistPath, this.songsPath) : super([]) {
    _setState();
    _listen();
  }

  String playlistPath;
  String songsPath;

  void _listen() {
    Directory(playlistPath).watch().listen((FileSystemEvent event) async {
      if (!mounted) return;

      if (event is FileSystemModifyEvent) return;

      try {
        _setState();
      } catch (e) {
        //
      }
    });
  }

  void _setState() {
    state = Directory(playlistPath).listSync(recursive: false).whereType<File>().toList().map((file) {
      return Playlist.fromJson(file.readAsStringSync(), songsPath);
    }).toList();

    state.sort((a, b) => a.title.compareTo(b.title));
  }
}
