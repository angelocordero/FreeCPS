import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';

import '../models/playlist_model.dart';

class PlaylistNotifier extends StateNotifier<Playlist> {
  PlaylistNotifier() : super(Playlist.empty()) {
    initPlaylist();
  }

  initPlaylist() {
    // get already selected playlist from hive database\
    testPlaylist();
  }

  changeCurrentPlaylist(String playlistPath) async {
    String songsDir = await songsDirectory();

    state = Playlist.fromJson(jsonDecode(File(playlistPath).readAsStringSync()), songsDir);
  }

  testPlaylist() async {
    try {
      String songsDir = await songsDirectory();

      Playlist playlist = Playlist.fromJson(File('/home/angelo/Dev/Flutter/freecps/media/playlist_template.json').readAsStringSync(), songsDir);
      state = playlist;
    } catch (e) {
      debugPrint(e.toString());
      state = Playlist.error();
    }
  }
}
