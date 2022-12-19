import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/notifiers/bible_reference_notifier.dart';

import '../core/providers_declaration.dart';
import '../models/bible_reference_model.dart';

class TranslationPicker extends ConsumerWidget {
  const TranslationPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BibleReference bibleRef = ref.watch(bibleReferenceProvider);
    BibleReferenceNotifier bibleRefNotifer = ref.watch(bibleReferenceProvider.notifier);

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton<String>(
        isDense: true,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        underline: Container(),
        value: bibleRef.translation,
        disabledHint: const Text('No Bibles Available'),
        elevation: 16,
        style: const TextStyle(color: Colors.lightBlueAccent),
        onChanged: (String? value) {
          bibleRefNotifer.translationRef = value;
        },
        items: bibleRefNotifer.getAvailableBibles?.map<DropdownMenuItem<String>>(
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
