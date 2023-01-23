import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MediaCenterPhotosNotifier extends StateNotifier<List<File>> {
  MediaCenterPhotosNotifier(this.path) : super([]) {
    _fetch();
    _listen();
  }

  Future<String> path;

  _fetch() async {
    state = Directory(await path).listSync(recursive: false).whereType<File>().toList();
  }

  _listen() async {
    Directory(await path).watch().listen((event) async {
      if (!mounted) return;

      state = Directory(await path).listSync(recursive: false).whereType<File>().toList();
    });
  }
}
