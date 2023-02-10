import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/file_utils.dart';
import '../../core/providers_declaration.dart';
import '../../models/playlist_model.dart';
import '../media_center_providers.dart';
import '../widgets/playlist_preview_panel.dart';

class MediaCenterPlaylistsTab extends ConsumerWidget {
  const MediaCenterPlaylistsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Playlist> playlists = ref.watch(playlistsProvider);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      String selectedFileName = ref.watch(previewedPlaylistProvider).fileName;
                      Playlist playlist = playlists[index];

                      String title = playlist.title;

                      if (playlist.fileName == ref.watch(activePlaylistProvider).fileName) {
                        title = '${playlist.title} (Active)';
                      }

                      return GestureDetector(
                        onTap: () {
                          ref.read(previewedPlaylistProvider.notifier).state = playlist;
                        },
                        child: ListTile(
                          selected: playlist.fileName == selectedFileName,
                          title: Text(title),
                        ),
                      );
                    },
                  ),
                ),
                const VerticalDivider(),
                const Flexible(
                  flex: 2,
                  child: PlaylistPreviewPanel(),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 2,
                  child: ref.watch(playlistPreviewProvider),
                ),
              ],
            ),
          ),
          _buttons(ref, context),
        ],
      ),
    );
  }

  Row _buttons(WidgetRef ref, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () async {
            FileUtils.addNewPlaylist();
          },
          child: const Text('Add New Playlist'),
        ),
        const SizedBox(
          width: 50,
        ),
        ElevatedButton(
          onPressed: () async {
            String fileName = ref.read(previewedPlaylistProvider).fileName;

            try {
              ref.read(activePlaylistProvider.notifier).select(fileName);
              Navigator.pop(context);
            } catch (e) {
              //
            }
          },
          child: const Text('Set As Active'),
        ),
        const SizedBox(
          width: 50,
        ),
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.custom,
              allowedExtensions: playlistFileExtension,
            );

            if (result == null) return;

            FileUtils.importPlaylist(FileUtils.filePickerResultToFile(result));
          },
          child: const Text('Import'),
        ),
      ],
    );
  }
}
