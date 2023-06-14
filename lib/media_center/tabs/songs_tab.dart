// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freecps/media_center/widgets/song_preview.dart';

import '../../core/constants.dart';
import '../../core/file_utils.dart';
import '../../core/providers_declaration.dart';
import '../../models/slide_model.dart';
import '../../models/song_model.dart';
import '../../widgets/song_slide_widget.dart';
import '../media_center_providers.dart';
import '../notifiers/song_editor_fields_data_notifier.dart';

final isEditingProvider = StateProvider.autoDispose<bool>((ref) {
  ref.watch(selectedSongProvider);

  return false;
});

class SongsTab extends ConsumerWidget {
  const SongsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Song> songs = ref.watch(songsProvider);
    Song selectedSong = ref.watch(selectedSongProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (input) {
                          if (input.isEmpty) {
                            ref.read(songsProvider.notifier).clearSearch();
                            return;
                          }

                          ref.read(songsProvider.notifier).search(input);
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            Song song = songs[index];

                            return GestureDetector(
                              onTap: () {
                                if (selectedSong == song) return;

                                ref.read(selectedSongProvider.notifier).state = song;
                              },
                              child: ListTile(
                                selected: selectedSong.fileName == song.fileName,
                                title: Text(song.title),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 2,
                  child: ref.watch(isEditingProvider) ? _SongEditor(selectedSong) : SongPreview(selectedSong),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 2,
                  child: _SongSlidePreview(
                    song: selectedSong,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(selectedSongProvider.notifier).state = Song.empty();

                bool isEditing = ref.read(isEditingProvider);

                ref.read(isEditingProvider.notifier).state = !isEditing;
              },
              child: const Text('New Song'),
            ),
            const SizedBox(
              width: 50,
            ),
            ElevatedButton(
              onPressed: () {
                if (ref.read(selectedSongProvider) == Song.empty()) return;

                bool isEditing = ref.read(isEditingProvider);

                ref.read(isEditingProvider.notifier).state = !isEditing;
              },
              child: const Text('Edit'),
            ),
            const SizedBox(
              width: 50,
            ),
            ElevatedButton(
              onPressed: () {
                FileUtils.addSongToPlaylist(selectedSong, ref.read(activePlaylistProvider));
              },
              child: const Text('Add To Playlist'),
            ),
            const SizedBox(
              width: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: songFileExtension,
                );

                if (result == null) return;

                FileUtils.importSongs(FileUtils.filePickerResultToFile(result));
              },
              child: const Text('Import'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SongSlidePreview extends StatelessWidget {
  const _SongSlidePreview({required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    List<SongSlide> slides = [];

    for (var entries in song.lyrics.entries) {
      String ref = entries.key;

      for (var element in entries.value) {
        slides.add(SongSlide(text: element, reference: ref));
      }
    }

    return GridView.builder(
      itemCount: slides.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 50,
        crossAxisSpacing: 50,
        childAspectRatio: 16 / 10.675,
      ),
      itemBuilder: (context, index) {
        return SongSlideWidget(
          slide: slides[index],
          index: index,
          // TODO change this scalefactor to match slide size in preview
          scaleFactor: 1,
        );
      },
    );
  }
}

class _SongEditor extends ConsumerWidget {
  _SongEditor(this.song);

  final Song song;

  late final TextEditingController titleController = TextEditingController(text: song.title);
  late final TextEditingController artistController = TextEditingController(text: song.artist);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FieldData> fieldsData = ref.watch(songEditorFieldsDataNotifierProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(songEditorFieldsDataNotifierProvider.notifier).insertField();
              },
              child: const Text('Inser Slide in cursor position'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(songEditorFieldsDataNotifierProvider.notifier).save(
                      titleController: titleController,
                      artistController: artistController,
                    );
              },
              child: const Text('Save song'),
            ),
          ],
        ),
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
        Expanded(
          child: ListView.builder(
            itemCount: fieldsData.length,
            itemBuilder: (context, index) {
              FieldData fieldData = fieldsData[index];

              return _SongEditorTextFieldTile(
                label: fieldData.label,
                controller: fieldData.controller,
                index: index + 1,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SongEditorTextFieldTile extends ConsumerWidget {
  const _SongEditorTextFieldTile({required this.label, required this.controller, required this.index});

  final TextEditingController controller;
  final int index;
  final String label;

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
                ref.read(songEditorFieldsDataNotifierProvider.notifier).setCursorLocation(
                      textFieldIndex: index,
                      cursorPos: controller.selection.baseOffset,
                    );
              },
              onChanged: (input) {
                ref.read(songEditorFieldsDataNotifierProvider.notifier).setCursorLocation(
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
