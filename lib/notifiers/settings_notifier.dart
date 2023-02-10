import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/file_utils.dart';

class SettingsNotifier extends StateNotifier<Map<String, String>> {
  SettingsNotifier(this.fileName) : super({}) {
    _init();
  }

  String fileName;

  void _init() {
    try {
      state = Map<String, String>.from(jsonDecode(File(fileName).readAsStringSync()));
    } catch (e) {
      //
    }
  }

  void update(String key, String value) {
    state.update(
      key,
      (_) => value,
      ifAbsent: () => value,
    );

    state = Map<String, String>.from(state);

    FileUtils.saveSettings(state);
  }
}
