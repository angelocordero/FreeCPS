import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';
import 'package:freecps/core/file_utils.dart';
import 'package:path/path.dart';

import '../models/playlist_model.dart';

class PlaylistNotifier extends StateNotifier<Playlist> {
  PlaylistNotifier() : super(Playlist.empty()) {
    _init();
  }

  late String playlistDir;
  late String songsDir;

  _init() async {
    playlistDir = await playlistsDirectory();
    songsDir = await songsDirectory();

    //await testPlaylist();

    // get already selected playlist from hive database
    String? playlistFileName = 'playlist_template.json';

    await select(await FileUtils.getPlaylistPath(playlistFileName));

    await _listen();
  }

  _listen() async {
    Directory(playlistDir).watch().listen((event) async {

      if (event is FileSystemDeleteEvent) {
        if (event.path == await FileUtils.getPlaylistPath(state.fileName)) {
          // handle if playlist is deleted
          state = Playlist.empty();
          // TODO reset playlist selected options indicator
        }
      }

      if (event is FileSystemModifyEvent) {
        if (basename(event.path) == state.fileName) {
          //handle if playlist is modified
          await select(state.fileName);
        }
      }
    });
  }

  select(String fileName) async {
    String fileDir = await FileUtils.getPlaylistPath(fileName);

    try {
      state = Playlist.fromJson(File(fileDir).readAsStringSync(), songsDir);
      //save selected playlist filename to hive database
    } catch (e) {
      debugPrint(e.toString());
      state = Playlist.error();
    }
  }

  testPlaylist() async {
    await select(await FileUtils.getPlaylistPath('playlist_template.json'));
  }
}
