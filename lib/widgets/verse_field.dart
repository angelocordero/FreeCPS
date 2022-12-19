import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/bible_reference_model.dart';

import '../core/input_formatters.dart';
import '../notifiers/bible_reference_notifier.dart';

class VerseField extends ConsumerWidget {
  const VerseField({super.key});

  static final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BibleReference bibleRef = ref.watch(bibleReferenceProvider);
    BibleReferenceNotifier bibleRefNotifer = ref.watch(bibleReferenceProvider.notifier);

    _controller.text = bibleRef.verse.toString();
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    return SizedBox(
      width: 130,
      child: TextField(
        controller: _controller,
        enabled: bibleRef.translation != null,
        onChanged: (value) {
          bibleRefNotifer.verseRef = value;
        },
        inputFormatters: verseInputFormatters(max: bibleRefNotifer.getVerseMax),
      ),
    );
  }
}
