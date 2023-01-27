import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';

class PlaylistSongsExpansionTile extends ConsumerWidget {
  const PlaylistSongsExpansionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(activePlaylistProvider);

    return ExpansionTile(
      initiallyExpanded: true,
      title: const Text('Songs'),
      children: [
        ...playlist.songs.map(
          (song) {
            return GestureDetector(
              onTap: () {
                if (song.title != Song.error().title) {
                  ref.read(projectionSlidesProvider.notifier).generateSongSlide(song: song);
                }
              },
              child: Card(
                child: ListTile(
                  title: Text(song.title),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
