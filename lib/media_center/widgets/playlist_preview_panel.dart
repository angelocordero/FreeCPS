import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/helper_functions.dart';
import 'package:freecps/media_center/media_center_providers.dart';

import '../../models/playlist_model.dart';

class PlaylistPreviewPanel extends ConsumerWidget {
  const PlaylistPreviewPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(selectedPlaylistProvider);

    return ListView(
      children: [
        const Text('Songs'),
        ...playlist.songs
            .map((e) => ListTile(
                onTap: () {
                  ref.read(playlistPreviewProvider.notifier).preview(e);
                },
                title: Text(e.title)))
            .toList(),
        const Divider(),
        const Text('Verses'),
        ...playlist.verses.map(
          (e) => ListTile(
              onTap: () {
                ref.read(playlistPreviewProvider.notifier).preview(e);
              },
              title: Text(scriptureRefToRefString(e.scriptureRef))),
        ),
        const Divider(),
        const Text('Media'),
        ...playlist.media.map(
          (e) => ListTile(
            onTap: () {
              ref.read(playlistPreviewProvider.notifier).preview(e);
            },
            title: Text(e),
          ),
        ),
      ],
    );
  }
}
