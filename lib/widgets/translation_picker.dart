import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/notifiers/scripture_model_notifier.dart';

import '../core/providers_declaration.dart';
import '../models/scripture_model.dart';

class TranslationPicker extends ConsumerWidget {
  const TranslationPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);
    ScriptureNotifier scriptureNotifer = ref.watch(scriptureProvider.notifier);

    return ExcludeFocus(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          isDense: true,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          underline: Container(),
          value: scripture.scriptureRef.translation,
          disabledHint: const Text('No Bibles Available'),
          elevation: 16,
          style: const TextStyle(color: Colors.lightBlueAccent),
          onChanged: (String? value) {
            scriptureNotifer.translationRef = value;
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
      ),
    );
  }
}
