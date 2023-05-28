import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/file_utils.dart';

import '../../core/constants.dart';
import '../../core/helper_functions.dart';
import '../../models/song_model.dart';
import '../media_center_providers.dart';
import '../tabs/songs_tab.dart';

typedef CursorLocation = ({int textFieldIndex, int cursorPosition});
typedef FieldData = ({TextEditingController controller, String label});

//TODO: MASSIVE MASSIVE REFACTOR

class SongEditorLyricsFieldsNotifier extends StateNotifier<Widget> {
  SongEditorLyricsFieldsNotifier(this.song, this.ref) : super(Container()) {
    init();
  }

  final List<_SongEditorTextFieldTile> _fields = [];
  final List<FieldData> _fieldsData = [];

  Song song;

  AutoDisposeStateNotifierProviderRef<SongEditorLyricsFieldsNotifier, Widget> ref;

  CursorLocation? cursorLocation;

  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();

  void setCursorLocation({required int textFieldIndex, required int cursorPos}) {
    cursorLocation = (textFieldIndex: textFieldIndex - 1, cursorPosition: cursorPos);
  }

  init() {
    for (var entry in song.lyrics.entries) {
      for (var element in entry.value) {
        TextEditingController controller = TextEditingController.fromValue(TextEditingValue(text: element));
        _fieldsData.add((controller: controller, label: entry.key));
      }
    }

    titleController.text = song.title;
    artistController.text = song.artist;

    _setState();
  }

  insertSlide() {
    if (_fieldsData.isEmpty) {
      TextEditingController insertController = TextEditingController();

      _fieldsData.add((controller: insertController, label: 'Verse 1'));
      cursorLocation = null;

      _setState();

      return;
    }

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

  save() {
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

  Widget _textFieldList() {
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

      _fields.add(_SongEditorTextFieldTile(
        label: fieldData.label,
        controller: fieldData.controller,
        index: i + 1,
      ));
    }

    state = _textFieldList();
  }
}

class _SongEditorTextFieldTile extends ConsumerWidget {
  const _SongEditorTextFieldTile({required this.label, required this.controller, required this.index});

  final String label;
  final TextEditingController controller;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = catpuccinColorsSample[label] ?? Colors.blueGrey;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            color: color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(index.toString()),
                Text(label),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              textAlign: TextAlign.center,
              controller: controller,
              minLines: 5,
              maxLines: 10,
              onTap: () {
                ref.read(songEditorProvider.notifier).setCursorLocation(
                      textFieldIndex: index,
                      cursorPos: controller.selection.baseOffset,
                    );
              },
              onChanged: (input) {
                ref.read(songEditorProvider.notifier).setCursorLocation(
                      textFieldIndex: index,
                      cursorPos: controller.selection.baseOffset,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
