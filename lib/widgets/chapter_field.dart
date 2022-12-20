import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/scripture_model.dart';
import 'package:freecps/notifiers/scripture_model_notifier.dart';

import '../core/input_formatters.dart';
import '../models/bible_reference_model.dart';

class ChapterField extends ConsumerWidget {
  const ChapterField({super.key});

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScriptureModel scripture = ref.watch(scriptureModelProvider);
    ScriptureModelNotifier scriptureNotifier = ref.watch(scriptureModelProvider.notifier);

    _controller.text = scripture.chapter.toString();
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    _focusNode.addListener(
      () {
        if (_focusNode.hasFocus) {
          _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
        }
      },
    );

    return SizedBox(
      width: 130,
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        enabled: scripture.translation != null,
        onSubmitted: (value) {
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
        onChanged: (value) {
          if (value == '') {
            return;
          }

          scriptureNotifier.chapterRef = int.tryParse(value);
        },
        inputFormatters: chapterInputFormatters(max: scriptureNotifier.getChapterMax),
      ),
    );
  }
}
