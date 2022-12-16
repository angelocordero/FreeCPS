import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/bible_reference_model.dart';

import '../core/input_formatters.dart';

class VerseField extends ConsumerWidget {
  const VerseField({super.key});

  static final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BibleReference bibleRef = ref.watch(bibleReferenceProvider);

      _controller.text = bibleRef.verse ?? '1';
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
   

    return SizedBox(
      width: 130,
      child: TextField(
        controller: _controller,
        enabled: bibleRef.translation != null,
        onSubmitted: ((value) {
          ref.read(bibleReferenceProvider.notifier).updateVerse(value);
        }),
        inputFormatters: verseInputFormatters(max: ref.watch(versesProvider)?.length ?? 0),
      ),
    );
  }
}
