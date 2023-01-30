import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../core/providers_declaration.dart';
import '../models/scripture_model.dart';
import '../models/verse_model.dart';
import '../widgets/verse_list_tile.dart';

class VersesList extends ConsumerWidget {
  const VersesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);

    List<Verse>? verseList = scripture.verses ?? [];

    int startVerse = scripture.scriptureRef.verse?.verseRange.item1 ?? 0;
    int? endVerse = scripture.scriptureRef.verse?.verseRange.item2;

    return FocusScope(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ScrollablePositionedList.builder(
          itemScrollController: ref.watch(verseListControllerProvider),
          itemCount: verseList.length,
          itemBuilder: (context, index) {
            return VerseListTile(
              endVerse: endVerse,
              startVerse: startVerse,
              verseList: verseList,
              index: index,
            );
          },
        ),
      ),
    );
  }
}
