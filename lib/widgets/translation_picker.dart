import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/notifiers/scripture_model_notifier.dart';

import '../core/providers_declaration.dart';
import '../models/bible_reference_model.dart';
import '../models/scripture_model.dart';

class TranslationPicker extends ConsumerWidget {
  const TranslationPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScriptureModel scripture = ref.watch(scriptureModelProvider);
    ScriptureModelNotifier scriptureNotifer = ref.watch(scriptureModelProvider.notifier);

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton<String>(
        isDense: true,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        underline: Container(),
        value: scripture.translation,
        disabledHint: const Text('No Bibles Available'),
        elevation: 16,
        style: const TextStyle(color: Colors.lightBlueAccent),
        onChanged: (String? value) {
          scriptureNotifer.translationRef = value;

          ScriptureModel bibleRef = ref.read(scriptureModelProvider);
          ref.read(projectorSlidesProvider.notifier).generateScriptureSlides(
              verses: bibleRef.verses ?? [],
              bibleRef: BibleReference(
                translation: bibleRef.translation!,
                book: bibleRef.book!,
                chapter: bibleRef.chapter.toString(),
                verse: bibleRef.verse!,
              ),
              startVerse: bibleRef.startVerse!,
              endVerse: bibleRef.endVerse);
        },
        items: scriptureNotifer.getAvailableBibles?.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList() ??
            [],
      ),
    );
  }
}
