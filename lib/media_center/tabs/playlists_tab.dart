import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/file_utils.dart';
import '../../core/helper_functions.dart';
import '../../core/providers_declaration.dart';
import '../../models/playlist_model.dart';
import '../../models/saved_verse_slides.dart';
import '../../models/song_model.dart';
import '../media_center_providers.dart';

class PlaylistsTab extends ConsumerWidget {
  const PlaylistsTab({
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
                  child: _PlaylistDetailsPanel(),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 2,
                  child: ref.watch(playlistPreviewPanelProvider),
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

class _PlaylistDetailsPanel extends ConsumerWidget {
  const _PlaylistDetailsPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(previewedPlaylistProvider);
    dynamic selected = ref.watch(playlistSelectedPreviewProvider);

    return ListView(
      children: [
        const Text('Songs'),
        songsList(playlist, ref, selected),
        const Divider(),
        const Text('Verses'),
        versesList(playlist, ref, selected),
        const Divider(),
        const Text('Media'),
        mediaList(playlist, selected, ref)
      ],
    );
  }

  ReorderableListView mediaList(Playlist playlist, dynamic selected, WidgetRef ref) {
    return ReorderableListView(
      shrinkWrap: true,
      buildDefaultDragHandles: playlist.media.length > 1,
      children: [
        ...playlist.media.map(
          (e) => ListTile(
            key: ValueKey(e.hashCode),
            selected: selected is String && selected == e,
            onTap: () {
              ref.read(playlistSelectedPreviewProvider.notifier).state = e;
            },
            title: Text(e),
          ),
        ),
      ],
      onReorder: (oldIndex, newIndex) {
        List<String> state = playlist.media;

        if (newIndex > oldIndex) newIndex--;

        final String media = state.removeAt(oldIndex);
        state.insert(newIndex, media);

        Playlist newPlaylist = playlist.copyWith(media: state);

        ref.read(previewedPlaylistProvider.notifier).state = newPlaylist;

        FileUtils.savePlaylist(newPlaylist);
      },
    );
  }

  ReorderableListView versesList(Playlist playlist, WidgetRef ref, dynamic selected) {
    return ReorderableListView(
      buildDefaultDragHandles: playlist.verses.length > 1,
      shrinkWrap: true,
      children: [
        ...playlist.verses.map(
          (e) => ListTile(
            key: ValueKey(e.hashCode),
            onTap: () {
              ref.read(playlistSelectedPreviewProvider.notifier).state = e;
            },
            selected: selected is SavedVerseSlides && selected == e,
            title: Text(
              scriptureRefToString(e.scriptureRef),
            ),
          ),
        ),
      ],
      onReorder: (oldIndex, newIndex) {
        List<SavedVerseSlides> state = playlist.verses;

        if (newIndex > oldIndex) newIndex--;

        final SavedVerseSlides slide = state.removeAt(oldIndex);
        state.insert(newIndex, slide);

        Playlist newPlaylist = playlist.copyWith(verses: state);

        ref.read(previewedPlaylistProvider.notifier).state = newPlaylist;

        FileUtils.savePlaylist(newPlaylist);
      },
    );
  }

  ReorderableListView songsList(Playlist playlist, WidgetRef ref, dynamic selected) {
    return ReorderableListView(
      buildDefaultDragHandles: playlist.songs.length > 1,
      shrinkWrap: true,
      children: [
        ...playlist.songs
            .map(
              (e) => ListTile(
                key: ValueKey(e.hashCode),
                onTap: () {
                  ref.read(playlistSelectedPreviewProvider.notifier).state = e;
                },
                selected: selected is Song && selected == e,
                title: Text(e.title),
              ),
            )
            .toList(),
      ],
      onReorder: (oldIndex, newIndex) {
        List<Song> state = playlist.songs;

        if (newIndex > oldIndex) newIndex--;

        final Song song = state.removeAt(oldIndex);
        state.insert(newIndex, song);

        Playlist newPlaylist = playlist.copyWith(songs: state);

        ref.read(previewedPlaylistProvider.notifier).state = newPlaylist;

        FileUtils.savePlaylist(newPlaylist);
      },
    );
  }
}
