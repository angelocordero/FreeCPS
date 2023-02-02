import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/song_model.dart';

class SongsNotifier extends StateNotifier<List<Song>> {
  SongsNotifier(this.path) : super([]) {
    _fetch();
    _listen();
  }

  Future<String> path;

  _fetch() async {
    state = Directory(await path).listSync(recursive: false).whereType<File>().map(
      (file) {
        return Song.fromJson(
          file.readAsStringSync(),
        );
      },
    ).toList();
  }

  _listen() async {
    Directory(await path).watch().listen(
      (event) async {
        if (!mounted) return;

        try {
          state = Directory(await path).listSync(recursive: false).whereType<File>().map(
            (file) {
              return Song.fromJson(
                file.readAsStringSync(),
              );
            },
          ).toList();
        } catch (e) {
//
        }
      },
    );
  }
}
