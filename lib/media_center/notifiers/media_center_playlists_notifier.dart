import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/playlist_model.dart';

class MediaCenterPlaylistsNotifier extends StateNotifier<List<Playlist>> {
  MediaCenterPlaylistsNotifier(this.playlistPath, this.songsPath) : super([]) {
    init();
  }

  Future<String> playlistPath;
  Future<String> songsPath;

  init() {
    _fetch();
    _listen();
  }

  void _fetch() async {
    String path = await songsPath;

    try {
      await setState(path);
    } catch (e) {
      //
    }
  }

  void _listen() async {
    String path = await songsPath;

    Directory(await playlistPath).watch().listen((FileSystemEvent event) async {
      if (!mounted) return;

      if (event is FileSystemModifyEvent) return;

      try {
        await setState(path);
      } catch (e) {
        //
      }
    });
  }

  Future<void> setState(String path) async {
    state = Directory(await playlistPath).listSync(recursive: false).whereType<File>().toList().map((file) {
      return Playlist.fromJson(file.readAsStringSync(), path);
    }).toList();

    state.sort((a, b) => a.title.compareTo(b.title));
  }
}
