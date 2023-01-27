import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/input_formatters.dart';
import '../core/providers_declaration.dart';
import '../models/scripture_model.dart';
import '../notifiers/scripture_model_notifier.dart';

class VerseField extends ConsumerWidget {
  const VerseField({super.key});

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);
    ScriptureNotifier scriptureNotifer = ref.watch(scriptureProvider.notifier);

    _controller.text = scripture.scriptureRef.verse?.toDisplayString() ?? '1';
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    _focusNode.addListener(
      () {
        if (_focusNode.hasFocus) {
          _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
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
          scriptureNotifer.verseRef = value;

          ref.read(verseListControllerProvider.notifier).scrollToOffset(value);
        },
        inputFormatters: verseInputFormatters(max: scriptureNotifer.getVerseMax),
      ),
    );
  }
}
