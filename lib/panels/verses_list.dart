import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/scripture_model.dart';
import 'package:freecps/models/verse_reference_model.dart';

import '../models/verse_model.dart';

class VersesList extends ConsumerWidget {
  const VersesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);

    List<Verse>? map = scripture.verses ?? [];

    int startVerse = scripture.scriptureRef.verse!.verseRange.item1;
    int? endVerse = scripture.scriptureRef.verse!.verseRange.item2;

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.enter) || event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
          ref.read(projectorSlidesProvider.notifier).generateScriptureSlides(scripture: scripture);
          return;
        }

        if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.controlLeft) || event.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
          ref.read(verseListKeyboardNotifier.notifier).state = true;
          return;
        }

        ref.read(verseListKeyboardNotifier.notifier).state = false;
      },
      child: Padding(
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
                onTap: () {
                  if (ref.read(verseListKeyboardNotifier)) {
                    VerseReference? verseRef = ref.read(scriptureProvider).scriptureRef.verse;

                    if (verseRef == null) return;

                    if (verseRef.verseRange.item1 >= index + 1 && verseRef.verseRange.item2 != null) {
                      ref.read(scriptureProvider.notifier).verseRef = '${index + 1}-${verseRef.verseRange.item2}';
                      return;
                    }

                    ref.read(scriptureProvider.notifier).verseRef = '${verseRef.verseRange.item1}-${index + 1}';
                    return;
                  }

                  ref.read(scriptureProvider.notifier).verseRef = (index + 1).toString();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
