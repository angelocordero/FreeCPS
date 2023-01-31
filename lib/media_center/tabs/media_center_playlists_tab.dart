import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/file_utils.dart';
import 'package:freecps/media_center/widgets/playlist_preview_panel.dart';

import '../../core/providers_declaration.dart';
import '../../models/playlist_model.dart';
import '../media_center_providers.dart';

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
                      String selectedFileName = ref.watch(selectedPlaylistProvider).fileName;
                      Playlist playlist = playlists[index];
                      return GestureDetector(
                        onTap: () {
                          ref.read(selectedPlaylistProvider.notifier).state = playlist;
                        },
                        child: ListTile(
                          selected: playlist.fileName == selectedFileName,
                          title: Text(playlist.title),
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
            String fileName = ref.read(selectedPlaylistProvider).fileName;

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
          onPressed: () async {},
          child: const Text('Import'),
        ),
      ],
    );
  }
}
