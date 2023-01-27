import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import '../models/scripture_model.dart';

class ScriptureSettings extends ConsumerWidget {
  const ScriptureSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(projectionSlidesProvider.notifier).generateScriptureSlides(scripture: scripture);
            },
            child: const Text('Generate Verse Slides'),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              Playlist playlist = ref.read(activePlaylistProvider);

              ref.read(projectionSlidesProvider.notifier).saveScriptureSlideToPlaylist(playlist);
            },
            child: const Text('Save Verses To Playlist'),
          ),
        ],
      ),
    );
  }
}
