import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';

import '../core/constants.dart';
import '../core/file_utils.dart';
import '../models/playlist_model.dart';

class PlaylistNotifier extends StateNotifier<Playlist> {
  PlaylistNotifier() : super(Playlist.empty()) {
    _init();
  }

  late String playlistDir;
  late String songsDir;

  select(String fileName) async {
    String fileDir = await FileUtils.getPlaylistPath(fileName);
 

    try {
      state = Playlist.fromJson(File(fileDir).readAsStringSync(), songsDir);

      // save selected playlist filename to hive database
      Hive.box('settings').put('playlist', fileName);
    } catch (e) {
      debugPrint(e.toString());
      state = Playlist.error();
    }
  }

  _init() async {
    playlistDir = await playlistsDirectory();
    songsDir = await songsDirectory();

    // get already selected playlist from hive database
    String? playlistFileName = Hive.box('settings').get('playlist');

    if (playlistFileName != null) {
      await select( playlistFileName);
    }

    await _listen();
  }

  _listen() async {
    Directory(playlistDir).watch(recursive: true).listen((event) async {
      if (event is FileSystemDeleteEvent) {
        if (event.path == await FileUtils.getPlaylistPath(state.fileName)) {
          // handle if playlist is deleted
          state = Playlist.empty();
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
}
