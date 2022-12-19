import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/bible_reference_model.dart';
import 'package:freecps/notifiers/bible_reference_notifier.dart';

import '../core/input_formatters.dart';

class ChapterField extends ConsumerWidget {
  const ChapterField({super.key});

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BibleReference bibleRef = ref.watch(bibleReferenceProvider);
    BibleReferenceNotifier bibleRefNotifier = ref.watch(bibleReferenceProvider.notifier);

    _controller.text = bibleRef.chapter.toString();
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
        enabled: bibleRef.translation != null,
        onChanged: (value) {
          if (value == '') {
            return;
          }

          bibleRefNotifier.chapterRef = int.tryParse(value);
        },
        inputFormatters: chapterInputFormatters(max: bibleRefNotifier.getChapterMax),
      ),
    );
  }
}
