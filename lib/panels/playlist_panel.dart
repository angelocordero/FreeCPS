import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import '../widgets/playlist_media_expansion_tile.dart';
import '../widgets/playlist_songs_expansion_tile.dart';
import '../widgets/playlist_verses_expansion_tile.dart';

class PlaylistPanel extends ConsumerWidget {
  const PlaylistPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(activePlaylistProvider);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(playlist.title),
            const Divider(),
            const PlaylistSongsExpansionTile(),
            const Divider(),
            const PlaylistVersesExpansionTile(),
            const Divider(),
            const PlaylistMediaExpansionTile(),
          ],
        ),
      ),
    );
  }
}
