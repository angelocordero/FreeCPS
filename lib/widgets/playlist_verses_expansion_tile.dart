import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/helper_functions.dart';
import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import '../models/saved_verse_slides.dart';

class PlaylistVersesExpansionTile extends ConsumerWidget {
  const PlaylistVersesExpansionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(activePlaylistProvider);

    return ExpansionTile(
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
    );
  }
}
