import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MediaCenterVideosNotifier extends StateNotifier<List<File>> {
  MediaCenterVideosNotifier(this.path) : super([]) {
    _setState();
    _listen();
  }

  String path;

  _listen() {
    Directory(path).watch().listen((event) {
      if (!mounted) return;

      try {
        _setState();
      } catch (e) {
        //
      }
    });
  }

  void _setState() {
    state = Directory(path).listSync(recursive: false).whereType<File>().toList();
  }
}
