import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/scripture_model.dart';
import 'package:freecps/notifiers/scripture_model_notifier.dart';

import '../core/input_formatters.dart';

class ChapterField extends ConsumerWidget {
  const ChapterField({super.key});

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);
    ScriptureNotifier scriptureNotifier = ref.watch(scriptureProvider.notifier);

    _controller.text = scripture.scriptureRef.chapter.toString();
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    _focusNode.addListener(
      () {
        if (_focusNode.hasFocus) {
          _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
          return;
        } else if (_controller.text.isEmpty) {
          _controller.text = '1';
          _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
        }
      },
    );

    return SizedBox(
      width: 130,
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        enabled: scripture.scriptureRef.translation != null,
        onSubmitted: (value) {
          ref.read(projectionSlidesProvider.notifier).generateScriptureSlides(scripture: scripture);
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
