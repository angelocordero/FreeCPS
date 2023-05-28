import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/file_utils.dart';
import '../core/helper_functions.dart';
import '../core/projection_utils.dart';
import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import '../models/saved_verse_slides.dart';
import '../models/song_model.dart';

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
            const _PlaylistSongsExpansionTile(),
            const Divider(),
            const _PlaylistVersesExpansionTile(),
            const Divider(),
            const _PlaylistMediaExpansionTile(),
          ],
        ),
      ),
    );
  }
}

class _PlaylistVersesExpansionTile extends ConsumerWidget {
  const _PlaylistVersesExpansionTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(activePlaylistProvider);

    return ExpansionTile(
      initiallyExpanded: true,
      title: const Text('Verses'),
      children: [
        ...playlist.verses.map(
          (SavedVerseSlides savedVerseSlides) {
            String displayString = scriptureRefToString(savedVerseSlides.scriptureRef);

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
    );
  }
}

class _PlaylistMediaExpansionTile extends ConsumerWidget {
  const _PlaylistMediaExpansionTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(activePlaylistProvider);

    return ExpansionTile(
      initiallyExpanded: true,
      title: const Text('Media'),
      children: [
        ...playlist.media.map(
          (media) {
            return GestureDetector(
              onTap: () async {
                try {
                  String filePath = '';

                  for (var element in videoFileExtensions) {
                    if (media.toLowerCase().contains(element)) {
                      filePath = await FileUtils.getVideoFilePath(media);
                    }
                  }

                  for (var element in photoFileExtensions) {
                    if (media.toLowerCase().contains(element)) {
                      filePath = await FileUtils.getPhotoFilePath(media);
                    }
                  }

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
    );
  }
}

class _PlaylistSongsExpansionTile extends ConsumerWidget {
  const _PlaylistSongsExpansionTile();

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
