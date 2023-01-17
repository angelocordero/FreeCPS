import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

import '../core/constants.dart';

typedef VideoData = Tuple2<String, String>;

class MediaCenterVideosNotifier extends StateNotifier<List<VideoData>> {
  MediaCenterVideosNotifier() : super([]) {
    _fetch();
    _listen();
  }

  _fetch() async {
    String path = await videosDirectory();
    state = Directory(path).listSync(recursive: false).whereType<File>().map((file) {
      return VideoData(file.path, basename(file.path));
    }).toList();
  }

  _listen() async {
    String path = await videosDirectory();
    Directory(path).watch().listen((event) {
      if (!mounted) return;

      state = Directory(path).listSync(recursive: false).whereType<File>().map((file) {
      return VideoData(file.path, basename(file.path));
    }).toList();
    });
  }
}
