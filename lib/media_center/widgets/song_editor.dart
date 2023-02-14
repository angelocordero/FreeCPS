import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../media_center_providers.dart';
import '../tabs/media_center_songs_tab.dart';

class SongEditor extends ConsumerWidget {
  const SongEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(songEditorProvider.notifier).insertSlide();
              },
              child: const Text('Inser Slide in cursor position'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(songEditorProvider.notifier).save();

                bool isEditing = ref.read(isEditingProvider);

                ref.read(isEditingProvider.notifier).state = !isEditing;
              },
              child: const Text('Save song'),
            ),
          ],
        ),
        ref.watch(songEditorProvider),
      ],
    );
  }
}
