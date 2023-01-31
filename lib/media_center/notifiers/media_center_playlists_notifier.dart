import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/playlist_model.dart';

class MediaCenterPlaylistsNotifier extends StateNotifier<List<Playlist>> {
  MediaCenterPlaylistsNotifier(this.playlistPath, this.songsPath) : super([])  {
    _fetch();
    _listen();
  }

  Future<String> playlistPath;
  Future<String> songsPath;

  void _fetch() async {
    String path = await songsPath;

    state = Directory(await playlistPath).listSync(recursive: false).whereType<File>().toList().map((file) {
      return Playlist.fromJson(file.readAsStringSync(), path);
    }).toList();
  }

  void _listen() async {
    String path = await songsPath;

    Directory(await playlistPath).watch().listen((event) async {
      if (!mounted) return;

      state = Directory(await playlistPath).listSync(recursive: false).whereType<File>().toList().map((file) {
        return Playlist.fromJson(file.readAsStringSync(), path);
      }).toList();
    });
  }
}
