import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/scripture_model.dart';
import 'package:freecps/notifiers/bible_reference_notifier.dart';

import '../core/input_formatters.dart';

class ChapterField extends ConsumerWidget {
  const ChapterField({super.key});

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScriptureModel scripture = ref.watch(ScriptureModelProvider);
    ScriptureModelNotifier scriptureNotifier = ref.watch(ScriptureModelProvider.notifier);

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
