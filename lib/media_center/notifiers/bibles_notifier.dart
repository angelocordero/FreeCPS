import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

typedef BibleData = ({String name, String translationName});

class BiblesNotifier extends StateNotifier<List<BibleData>> {
  BiblesNotifier(this.path) : super([]) {
    _setState();
    _listen();
  }

  String path;

  _listen() {
    Directory(path).watch().listen(
      (event) {
        if (!mounted) return;

        try {
          _setState();
        } catch (e) {
          //
        }
      },
    );
  }

  void _setState() {
    state = Directory(path).listSync(recursive: false).whereType<Directory>().map(
      (Directory dir) {
        String name = basenameWithoutExtension(dir.path);

        String translationName = jsonDecode(File(join(dir.path, '$name.metadata.json')).readAsStringSync())['translationName'];

        return (name: name, translationName: translationName);
      },
    ).toList();
  }
}
