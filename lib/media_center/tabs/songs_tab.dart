import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/media_center/widgets/song_preview.dart';

import '../../core/constants.dart';
import '../../core/file_utils.dart';
import '../../core/providers_declaration.dart';
import '../../models/song_model.dart';
import '../../models/song_slide_model.dart';
import '../../widgets/song_slide_widget.dart';
import '../media_center_providers.dart';
import '../notifiers/song_editor_lyrics_fields_notifier.dart';

final songEditorProvider = StateNotifierProvider.autoDispose<SongEditorLyricsFieldsNotifier, Widget>((ref) {
  Song song = ref.watch(selectedSongProvider);

  return SongEditorLyricsFieldsNotifier(song, ref);
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
                  child: ref.watch(isEditingProvider) ? const _SongEditor() : SongPreview(song: selectedSong),
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
        mainAxisExtent: 170,
      ),
      itemBuilder: (context, index) {
        return SongSlideWidget(
          text: slides[index].text,
          reference: slides[index].reference!,
          index: index,
        );
      },
    );
  }
}

class _SongEditor extends ConsumerWidget {
  const _SongEditor();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(songEditorProvider.notifier).insertSlide();
              },
              child: const Text('Inser Slide in cursor position'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(songEditorProvider.notifier).save();
              },
              child: const Text('Save song'),
            ),
          ],
        ),
        ref.watch(songEditorProvider),
      ],
    );
  }
}
