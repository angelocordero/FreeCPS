import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

typedef VideoData = Tuple2<String, String>;

class MediaCenterVideosNotifier extends StateNotifier<List<VideoData>> {
  MediaCenterVideosNotifier(this.path) : super([]) {
    _fetch();
    _listen();
  }

  Future<String> path;

  _fetch() async {
    state = Directory(await path).listSync(recursive: false).whereType<File>().map((file) {
      return VideoData(file.path, basename(file.path));
    }).toList();
  }

  _listen() async {
    Directory(await path).watch().listen((event) async {
      if (!mounted) return;

      state = Directory(await path).listSync(recursive: false).whereType<File>().map((file) {
        return VideoData(file.path, basename(file.path));
      }).toList();
    });
  }
}
