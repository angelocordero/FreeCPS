import 'package:flutter/material.dart';
import 'package:freecps/core/file_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/helper_functions.dart';
import '../../models/song_model.dart';
import '../media_center_providers.dart';
import '../tabs/songs_tab.dart';

part 'song_editor_fields_notifier.g.dart';

/// Index of lyrics field and the position of the cursor in the field
typedef CursorLocation = ({int textFieldIndex, int cursorPosition});
typedef FieldData = ({TextEditingController controller, String label});

@riverpod
class SongEditorFieldsNotifier extends _$SongEditorFieldsNotifier {
  @override
  List<FieldData> build() {
    Song song = ref.watch(selectedSongProvider);

    List<FieldData> buffer = [];

    for (var entry in song.lyrics.entries) {
      for (var element in entry.value) {
        TextEditingController controller = TextEditingController.fromValue(TextEditingValue(text: element));
        buffer.add((controller: controller, label: entry.key));
      }
    }

    return buffer;
  }

  CursorLocation? cursorLocation;

  void setCursorLocation({required int textFieldIndex, required int cursorPos}) {
    cursorLocation = (textFieldIndex: textFieldIndex - 1, cursorPosition: cursorPos);
  }

  /// changes the lyrics group of all the fields below the index to match the group of the index
  void changeFieldGroup(int index, String selectedLabel) {
    for (int i = index - 1; i < state.length; i++) {
      state[i] = (controller: state[i].controller, label: selectedLabel);
    }

    state = List.from(state);
  }

  // adds a field to the list
  void insertField() {
    // if there are no fields, adds field to begin the list and return
    if (state.isEmpty) {
      return _insertFirstField();
    }

    // if there are fields, insert a field to the cursor location
    // splits the text based on the cursor
    // puts text after the cursor into the newly inserted field

    if (cursorLocation == null) {
      _insertLastField();
    }

    int index = cursorLocation!.textFieldIndex;
    int cursorPos = cursorLocation!.cursorPosition;

    String text = state[index].controller.text;

    String text1 = text.substring(0, cursorPos).trim();
    String text2 = text.substring(cursorPos, text.length).trim();

    state[index].controller.text = text1;

    TextEditingController insertController = TextEditingController(text: text2);

    state.insert(index + 1, (controller: insertController, label: state[index].label));

    cursorLocation = null;

    state = List.from(state);
  }

  void _insertLastField() {
    int lastFieldIndex = state.length - 1;
    int lastCursorPosInLastField = state.last.controller.text.length;

    cursorLocation = (textFieldIndex: lastFieldIndex, cursorPosition: lastCursorPosInLastField);
  }

  void _insertFirstField() {
    TextEditingController insertController = TextEditingController();

    state.add((controller: insertController, label: 'Verse 1'));
    cursorLocation = null;

    state = List.from(state);
  }

  save({
    required TextEditingController titleController,
    required TextEditingController artistController,
  }) {
    Song song = ref.read(selectedSongProvider);

    if (titleController.text.isEmpty) return;
    if (state.isEmpty) return;

    Map<String, List<dynamic>> lyrics = {};
    List<String> sections = state.map((fields) => fields.label).toList();

    for (String section in sections) {
      lyrics[section] = state
          .where(
            (fields) => fields.label == section && fields.controller.text.isNotEmpty,
          )
          .map(
            (field) => field.controller.text.trim(),
          )
          .toList();
    }

    song = song.copyWith(
      lyrics: lyrics,
      title: titleController.text.trim(),
      artist: artistController.text.trim(),
    );

    if (song.fileName.isEmpty) {
      String fileName = '${generateRandomID()}.cpss';

      song = song.copyWith(fileName: fileName);
    }

    FileUtils.saveSong(song);

    bool isEditing = ref.read(isEditingProvider);

    ref.read(isEditingProvider.notifier).state = !isEditing;
    ref.read(editedSongProvider.notifier).state = song;
  }
}
