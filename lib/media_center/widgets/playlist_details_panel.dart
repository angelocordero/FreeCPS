import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/file_utils.dart';
import '../../core/helper_functions.dart';
import '../../models/playlist_model.dart';
import '../../models/saved_verse_slides.dart';
import '../../models/song_model.dart';
import '../media_center_providers.dart';

class PlaylistDetailsPanel extends ConsumerWidget {
  const PlaylistDetailsPanel({super.key});

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
