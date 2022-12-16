import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers_declaration.dart';

class TranslationPicker extends ConsumerWidget {
  const TranslationPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? selected = ref.watch(bibleReferenceProvider).translation;
    List<String>? items = ref.watch(availableBiblesProvider);

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton<String>(
        isDense: true,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        underline: Container(),
        value: selected,
        disabledHint: const Text('No Bibles Available'),
        elevation: 16,
        style: const TextStyle(color: Colors.lightBlueAccent),
        onChanged: (String? value) {
          ref.read(bibleReferenceProvider.notifier).updateTranslation(translation: value ?? '');
        },
        items: items?.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList() ?? [],
      ),
    );
  }
}
