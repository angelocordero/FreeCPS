import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/file_utils.dart';
import '../../core/providers_declaration.dart';
import '../../models/song_model.dart';
import '../media_center_providers.dart';
import '../widgets/song_preview.dart';
import '../widgets/song_slide_preview.dart';

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
                          selected: selectedSong == song,
                          title: Text(song.title),
                        ),
                      );
                    },
                  ),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 2,
                  child: selectedSong == Song.empty()
                      ? Container()
                      : SongPreview(
                          song: selectedSong,
                        ),
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
