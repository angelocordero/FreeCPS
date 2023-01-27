import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';

import '../../core/constants.dart' as constants;
import '../../core/file_utils.dart';
import '../../models/song_model.dart';
import '../media_center_providers.dart';

class MediaCenterSongsTab extends ConsumerWidget {
  const MediaCenterSongsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Song> songs = ref.watch(songsProvider);
    Set<Song> selectedSongs = ref.watch(selectedSongProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              itemCount: songs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                mainAxisExtent: 200,
              ),
              itemBuilder: (context, index) {
                Song song = songs[index];

                return GestureDetector(
                  onTap: () {
                    bool ctrlKey = ref.read(mediaCenterCtrlKeyNotifier);

                    if (!ctrlKey) {
                      ref.read(selectedSongProvider.notifier).state = {song};
                    } else {
                      ref.read(selectedSongProvider.notifier).update((state) => {...state, song});
                    }
                  },
                  child: Card(
                    shape: selectedSongs.contains(song)
                        ? const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xff1e66f5),
                              width: 1.5,
                            ),
                          )
                        : null,
                    child: Center(
                      child: Text(song.title),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                FileUtils.addSongToPlaylist(selectedSongs, ref.read(activePlaylistProvider));
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
                  allowedExtensions: constants.songFileExtension,
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
