import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/media_center/widgets/song_editor.dart';
import 'package:freecps/media_center/widgets/song_preview.dart';

import '../../core/constants.dart';
import '../../core/file_utils.dart';
import '../../core/providers_declaration.dart';
import '../../models/song_model.dart';
import '../media_center_providers.dart';
import '../notifiers/song_editor_lyrics_fields_notifier.dart';
import '../widgets/song_slide_preview.dart';

final songEditorProvider = StateNotifierProvider.autoDispose<SongEditorLyricsFieldsNotifier, Widget>((ref) {
  Song song = ref.watch(selectedSongProvider);

  return SongEditorLyricsFieldsNotifier(song, ref);
});

class MediaCenterSongsTab extends ConsumerWidget {
  const MediaCenterSongsTab({
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
                const VerticalDivider(),
                Flexible(
                  flex: 2,
                  child: ref.watch(isEditingProvider) ? const SongEditor() : SongPreview(song: selectedSong),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 2,
                  child: SongSlidePreview(
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
