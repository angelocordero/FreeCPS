import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';

import '../models/playlist_model.dart';

class MediaCenterPlaylistsNotifier extends StateNotifier<List<Playlist>> {
  MediaCenterPlaylistsNotifier(this.path) : super([]) {
    _fetch();
    _listen();
  }

  Future<String> path;

  _fetch() async {
    String songsDir = await songsDirectory();

    state = Directory(await path).listSync(recursive: false).whereType<File>().toList().map((file) {
      return Playlist.fromJson(file.readAsStringSync(), songsDir);
    }).toList();
  }

  _listen() async {
    Directory(await path).watch().listen((event) async {
      if (!mounted) return;

      // state = Directory(await path).listSync(recursive: false).whereType<File>().toList();
    });
  }
}
