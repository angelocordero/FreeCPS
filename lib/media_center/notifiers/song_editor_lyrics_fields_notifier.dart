import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/file_utils.dart';
import 'package:freecps/media_center/widgets/song_editor_text_field_tile.dart';
import 'package:tuple/tuple.dart';

import '../../models/song_model.dart';

typedef CursorPosition = Tuple2<int, int>;
typedef FieldData = Tuple2<TextEditingController, String>;

//TODO: MASSIVE MASSIVE REFACTOR

class SongEditorLyricsFieldsNotifier extends StateNotifier<Widget> {
  SongEditorLyricsFieldsNotifier(this.song) : super(Container()) {
    init();
  }

  final List<SongEditorTextFieldTile> _fields = [];
  final List<FieldData> _fieldsData = [];

  final Song song;

  CursorPosition? cursorPosition;

  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();

  void setCursorPosition({required int fieldIndex, required int cursorPos}) {
    cursorPosition = CursorPosition(fieldIndex - 1, cursorPos);
  }

  void resetCursorPosition() {
    cursorPosition == null;
  }

  init() {
    for (var entry in song.lyrics.entries) {
      for (var element in entry.value) {
        TextEditingController controller = TextEditingController.fromValue(TextEditingValue(text: element));
        _fieldsData.add(FieldData(controller, entry.key));
      }
    }

    _setState();
  }

  insertSlide() {
    if (cursorPosition == null) return;

    int index = cursorPosition!.item1;
    int cursorPos = cursorPosition!.item2;

    String text = _fieldsData[index].item1.text;

    String text1 = text.substring(0, cursorPos);
    String text2 = text.substring(cursorPos, text.length);

    _fieldsData[index].item1.text = text1;

    TextEditingController insertController = TextEditingController(text: text2);

    _fieldsData.insert(index + 1, FieldData(insertController, _fieldsData[index].item2));

    _setState();
  }

  test() {
    if (cursorPosition == null) return;

    String label = _fieldsData[cursorPosition!.item1].item2;

    for (int i = 0; i < _fieldsData.length; i++) {
      _fieldsData[i] = _fieldsData[i].withItem2(label);
    }

    _setState();
  }

  save() {
    Map<String, List<dynamic>> lyrics = {};
    List<String> sections = _fieldsData.map((e) => e.item2).toList();

    for (String section in sections) {
      lyrics[section] = _fieldsData.where((element) => element.item2 == section && element.item1.text.isNotEmpty).map((e) => e.item1.text).toList();
    }

    Song editedSong = song.copyWith(lyrics: lyrics, title: titleController.text, artist: artistController.text);

    FileUtils.saveSong(editedSong);
  }

  Widget _textFieldList(String title, String artist) {
    titleController.text = title;
    artistController.text = artist;

    return Expanded(
      child: ListView(
        children: [
          Row(
            children: [
              const Text('Title: '),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 2,
                child: TextField(
                  controller: titleController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Artist: '),
              const Spacer(
                flex: 1,
              ),
              Flexible(
                flex: 2,
                child: TextField(
                  controller: artistController,
                  onTap: () {},
                ),
              ),
            ],
          ),
          ..._fields,
        ],
      ),
    );
  }

  void _setState() {
    _fields.clear();

    for (int i = 0; i < _fieldsData.length; i++) {
      FieldData fieldData = _fieldsData[i];

      _fields.add(SongEditorTextFieldTile(
        label: fieldData.item2,
        controller: fieldData.item1,
        index: i + 1,
      ));
    }

    state = _textFieldList(song.title, song.artist);
  }
}
