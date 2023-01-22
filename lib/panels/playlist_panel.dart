import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/file_utils.dart';
import 'package:freecps/core/projection_utils.dart';
import 'package:freecps/core/providers_declaration.dart';

import '../models/playlist_model.dart';

class PlaylistPanel extends ConsumerWidget {
  const PlaylistPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(playlistProvider);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(playlist.title),
            const Divider(),
            ExpansionTile(
              initiallyExpanded: true,
              title: const Text('Songs'),
              children: [
                ...playlist.songs.map(
                  (song) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(projectionSlidesProvider.notifier).generateSongSlide(song: song);
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
            ),
            const Divider(),
            ExpansionTile(
              initiallyExpanded: true,
              title: const Text('Media'),
              children: [
                ...playlist.media.map(
                  (media) {
                    return GestureDetector(
                      onTap: () async {
                        try {
                          String filePath = await FileUtils.getVideoFilePath(media);
                          bool isLive = ref.read(liveProvider);
                          await ProjectionUtils.setBackground(filePath, isLive);
                        } catch (e) {
                          //
                        }
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(media),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
