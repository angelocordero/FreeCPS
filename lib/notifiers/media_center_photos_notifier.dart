import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';

class MediaCenterPhotosNotifier extends StateNotifier<List<File>> {
  MediaCenterPhotosNotifier() : super([]) {
    _fetch();
    _listen();
  }

  _fetch() async {
    String path = await photoThumbnailsDirectory();
    state = Directory(path).listSync(recursive: false).whereType<File>().toList();
  }

  _listen() async {
    String path = await photoThumbnailsDirectory();
    Directory(path).watch().listen((event) {
      if (!mounted) return;

      state = Directory(path).listSync(recursive: false).whereType<File>().toList();
    });
  }
}
