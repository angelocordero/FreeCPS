import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/bible_reference_model.dart';

import '../core/input_formatters.dart';

class ChapterField extends ConsumerWidget {
  const ChapterField({super.key});

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BibleReference bibleRef = ref.watch(bibleReferenceProvider);

    _controller.text = bibleRef.chapter.toString();
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    _focusNode.addListener(
      () {
        if (!_focusNode.hasFocus) {
          ref.read(bibleReferenceProvider.notifier).updateVerse('1');
          if (_controller.text == '0') {
            ref.read(bibleReferenceProvider.notifier).updateChapter(1);
          } else {
            ref.read(bibleReferenceProvider.notifier).updateChapter(int.tryParse(_controller.text) ?? 1);
          }
        }
      },
    );

    return SizedBox(
      width: 130,
      child: TextField(
        focusNode: _focusNode,
        enabled: bibleRef.translation != null,
        onChanged: (value) {
          if (value == '') {
            return;
          }

          ref.read(bibleReferenceProvider.notifier).updateChapter(int.parse(value));
        },
        controller: _controller,
        inputFormatters: chapterInputFormatters(
          max: ref.watch(selectedTranslationDataProvider)?['books'][bibleRef.book] ?? 0,
        ),
      ),
    );
  }
}
