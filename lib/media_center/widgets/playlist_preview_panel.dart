import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/helper_functions.dart';
import 'package:freecps/media_center/media_center_providers.dart';
import 'package:freecps/models/saved_verse_slides.dart';

import '../../core/file_utils.dart';
import '../../models/playlist_model.dart';
import '../../models/song_model.dart';

class PlaylistPreviewPanel extends ConsumerWidget {
  const PlaylistPreviewPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(previewedPlaylistProvider);
    dynamic selected = ref.watch(playlistPreviewSelectedObjectProvider);

    return ListView(
      children: [
        const Text('Songs'),
        ReorderableListView(
            shrinkWrap: true,
            children: [
              ...playlist.songs
                  .map(
                    (e) => ListTile(
                      key: ValueKey(e.hashCode),
                      onTap: () {
                        ref.read(playlistPreviewSelectedObjectProvider.notifier).state = e;
                      },
                      selected:  selected is Song && selected == e ,
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
            }),
        const Divider(),
        const Text('Verses'),
        ...playlist.verses.map(
          (e) => ListTile(
              onTap: () {
                ref.read(playlistPreviewSelectedObjectProvider.notifier).state = e;
              },
              selected:  selected is SavedVerseSlides && selected == e ,
              title: Text(scriptureRefToRefString(e.scriptureRef))),
        ),
        const Divider(),
        const Text('Media'),
        ...playlist.media.map(
          (e) => ListTile(
            selected:  selected is String && selected == e ,
            onTap: () {
              ref.read(playlistPreviewSelectedObjectProvider.notifier).state = e;
            },
            title: Text(e),
          ),
        ),
      ],
    );
  }
}
