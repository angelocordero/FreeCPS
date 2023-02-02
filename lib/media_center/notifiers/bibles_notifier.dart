import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

typedef BibleData = Tuple2<String, String>;

class BiblesNotifier extends StateNotifier<List<BibleData>> {
  BiblesNotifier(this.path) : super([]) {
    _fetch();
    _listen();
  }

  Future<String> path;

  _fetch() async {
    state = Directory(await path).listSync(recursive: false).whereType<Directory>().map(
      (Directory dir) {
        String name = basenameWithoutExtension(dir.path);

        String translationName = jsonDecode(File(join(dir.path, '$name.metadata.json')).readAsStringSync())['translationName'];

        return BibleData(name, translationName);
      },
    ).toList();
  }

  _listen() async {
    Directory(await path).watch().listen(
      (event) async {
        if (!mounted) return;

        try {
          state = Directory(await path).listSync(recursive: false).whereType<Directory>().map(
            (Directory dir) {
              String name = basenameWithoutExtension(dir.path);

              String translationName = jsonDecode(File(join(dir.path, '$name.metadata.json')).readAsStringSync())['translationName'];

              return BibleData(name, translationName);
            },
          ).toList();
        } catch (e) {
          //
        }
      },
    );
  }
}
