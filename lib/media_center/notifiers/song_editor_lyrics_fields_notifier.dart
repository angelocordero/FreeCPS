import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/file_utils.dart';

import '../../core/helper_functions.dart';
import '../../models/song_model.dart';
import '../media_center_providers.dart';
import '../tabs/songs_tab.dart';
import '../widgets/song_editor_text_field_tile.dart';

/// Index of lyrics field and the position of the cursor in the field
typedef CursorLocation = ({int textFieldIndex, int cursorPosition});
typedef FieldData = ({TextEditingController controller, String label});

class SongEditorLyricsFieldsNotifier extends StateNotifier<List<SongEditorTextFieldTile>> {
  SongEditorLyricsFieldsNotifier(this.song, this.ref) : super([]) {
    _init();
  }

  CursorLocation? cursorLocation;
  final AutoDisposeStateNotifierProviderRef<SongEditorLyricsFieldsNotifier, List<SongEditorTextFieldTile>> ref;
  Song song;

  final List<FieldData> _fieldsData = [];

  void setCursorLocation({required int textFieldIndex, required int cursorPos}) {
    cursorLocation = (textFieldIndex: textFieldIndex - 1, cursorPosition: cursorPos);
  }

  // adds a field to the list
  insertField() {
    // if there are no fields, adds field to begin the list and return
    if (_fieldsData.isEmpty) {
      TextEditingController insertController = TextEditingController();

      _fieldsData.add((controller: insertController, label: 'Verse 1'));
      cursorLocation = null;

      _setState();

      return;
    }

    // if there are fields, insert a field to the cursor location
    // splits the text based on the cursor
    // puts text after the cursor into the newly inserted field

    if (cursorLocation == null) return;

    int index = cursorLocation!.textFieldIndex;
    int cursorPos = cursorLocation!.cursorPosition;

    String text = _fieldsData[index].controller.text;

    String text1 = text.substring(0, cursorPos).trim();
    String text2 = text.substring(cursorPos, text.length).trim();

    _fieldsData[index].controller.text = text1;

    TextEditingController insertController = TextEditingController(text: text2);

    _fieldsData.insert(index + 1, (controller: insertController, label: _fieldsData[index].label));

    _setState();
  }

  save({
    required TextEditingController titleController,
    required TextEditingController artistController,
  }) {
    if (titleController.text.isEmpty) return;
    if (_fieldsData.isEmpty) return;

    Map<String, List<dynamic>> lyrics = {};
    List<String> sections = _fieldsData.map((fields) => fields.label).toList();

    for (String section in sections) {
      lyrics[section] = _fieldsData
          .where(
            (fields) => fields.label == section && fields.controller.text.isNotEmpty,
          )
          .map(
            (field) => field.controller.text.trim(),
          )
          .toList();
    }

    song = song.copyWith(lyrics: lyrics, title: titleController.text.trim(), artist: artistController.text.trim());

    if (song.fileName.isEmpty) {
      String fileName = '${generateRandomID()}.cpss';

      song = song.copyWith(fileName: fileName);
    }

    FileUtils.saveSong(song);

    bool isEditing = ref.read(isEditingProvider);

    ref.read(isEditingProvider.notifier).state = !isEditing;
    ref.read(editedSongProvider.notifier).state = song;
  }


  /// initializes the fields
  /// takes all labels, ie. Verses, Chorus, etc. and gets all lines of lyrics from each label
  /// assigns each line to a corresponding field
  _init() {
    for (var entry in song.lyrics.entries) {
      for (var element in entry.value) {
        TextEditingController controller = TextEditingController.fromValue(TextEditingValue(text: element));
        _fieldsData.add((controller: controller, label: entry.key));
      }
    }

    _setState();
  }

  void _setState() {
    state.clear();

    for (int i = 0; i < _fieldsData.length; i++) {
      FieldData fieldData = _fieldsData[i];

      state.add(SongEditorTextFieldTile(
        label: fieldData.label,
        controller: fieldData.controller,
        index: i + 1,
      ));
    }

    state = state.toList();
  }
}
