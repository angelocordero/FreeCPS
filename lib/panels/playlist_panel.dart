import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/file_utils.dart';
import 'package:freecps/core/helper_functions.dart';
import 'package:freecps/core/projection_utils.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/saved_verse_slides.dart';
import 'package:freecps/models/song_model.dart';

import '../models/playlist_model.dart';

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
            ExpansionTile(
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
            ),
            const Divider(),
            ExpansionTile(
              initiallyExpanded: true,
              title: const Text('Verses'),
              children: [
                ...playlist.verses.map(
                  (SavedVerseSlides savedVerseSlides) {
                    String displayString = scriptureRefToRefString(savedVerseSlides.scriptureRef);

                    return GestureDetector(
                      onTap: () async {
                        ref.read(projectionSlidesProvider.notifier).generateSavedVerseSlides(savedVerseSlides);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(displayString),
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
