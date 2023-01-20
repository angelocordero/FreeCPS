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
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: playlist.songs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    ref.read(projectionSlidesProvider.notifier).generateSongSlide(song: playlist.songs[index]);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(playlist.songs[index].title),
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: playlist.media.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    try {
                      String filePath = await FileUtils.getVideoFilePath(playlist.media[index]);

                      ProjectionUtils.setBackground(filePath);
                    } catch (e) {
                      //
                    }
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(playlist.media[index]),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
