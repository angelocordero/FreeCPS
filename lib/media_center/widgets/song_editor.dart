import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tabs/songs_tab.dart';

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
