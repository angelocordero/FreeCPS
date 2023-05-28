import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../core/providers_declaration.dart';
import '../models/scripture_model.dart';
import '../models/verse_model.dart';
import '../models/verse_reference_model.dart';

class VersesList extends ConsumerWidget {
  const VersesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);

    List<Verse>? verseList = scripture.verses ?? [];

    int startVerse = scripture.scriptureRef.verse?.verseRange.start ?? 0;
    int? endVerse = scripture.scriptureRef.verse?.verseRange.end;

    return FocusScope(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ScrollablePositionedList.builder(
          itemScrollController: ref.watch(verseListControllerProvider),
          itemCount: verseList.length,
          itemBuilder: (context, index) {
            return _VerseListTile(
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

class _VerseListTile extends ConsumerWidget {
  const _VerseListTile({
    Key? key,
    required this.endVerse,
    required this.startVerse,
    required this.verseList,
    required this.index,
  }) : super(key: key);

  final int? endVerse;
  final int index;
  final int startVerse;
  final List<Verse> verseList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        visualDensity: VisualDensity.compact,
        selected: endVerse != null ? ((index + 1) >= startVerse && (index + 1 <= endVerse!)) : (index + 1) == startVerse,
        selectedColor: Colors.black,
        selectedTileColor: Colors.lightBlue.shade50,
        title: Text(verseList[index].text),
        leading: Text((index + 1).toString()),
        onTap: () {
          VerseReference? verseRef = ref.read(scriptureProvider).scriptureRef.verse;

          if (ref.read(ctrlKeyNotifier)) {
            if (verseRef == null) return;

            if (verseRef.verseRange.end == null && verseRef.verseRange.start > index + 1) {
              ref.read(scriptureProvider.notifier).verseRef = '${index + 1}-${verseRef.verseRange.start}';
              return;
            }

            if (verseRef.verseRange.start > index + 1 && verseRef.verseRange.end != null) {
              ref.read(scriptureProvider.notifier).verseRef = '${index + 1}-${verseRef.verseRange.end}';
              return;
            }

            ref.read(scriptureProvider.notifier).verseRef = '${verseRef.verseRange.start}-${index + 1}';
            return;
          }

          ref.read(scriptureProvider.notifier).verseRef = (index + 1).toString();
        },
      ),
    );
  }
}
