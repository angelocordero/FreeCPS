import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/core/utils.dart';

import '../models/verse_model.dart';

class VersesList extends ConsumerWidget {
  const VersesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Verse>? map = ref.watch(scriptureProvider).verses ?? [];


    List<int?> verseRefList = Utils.verseListFromVerseString(ref.watch(scriptureProvider).scriptureRef.verse);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: map.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              visualDensity: VisualDensity.compact,
              selected:
                  verseRefList[1] != null ? ((index + 1) >= verseRefList[0]! && (index + 1 <= verseRefList[1]!)) : (index + 1) == verseRefList[0],
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
