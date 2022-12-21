import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/scripture_model.dart';

import '../models/verse_model.dart';

class VersesList extends ConsumerWidget {
  const VersesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);

    List<Verse>? map = scripture.verses ?? [];

    int startVerse = scripture.scriptureRef.verse!.verseRange.item1;
    int? endVerse = scripture.scriptureRef.verse!.verseRange.item2;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: map.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              visualDensity: VisualDensity.compact,
              selected: endVerse != null ? ((index + 1) >= startVerse && (index + 1 <= endVerse)) : (index + 1) == startVerse,
              selectedColor: Colors.black,
              selectedTileColor: Colors.lightBlue.shade50,
              title: Text(map[index].text),
              subtitle: Text((index + 1).toString()),
            ),
          );
        },
      ),
    );
  }
}
