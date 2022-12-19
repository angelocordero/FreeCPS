import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/scripture_model.dart';

import '../core/input_formatters.dart';
import '../notifiers/bible_reference_notifier.dart';

class VerseField extends ConsumerWidget {
  const VerseField({super.key});

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScriptureModel scripture = ref.watch(ScriptureModelProvider);
    ScriptureModelNotifier scriptureNotifer = ref.watch(ScriptureModelProvider.notifier);

    _controller.text = scripture.verse.toString();
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
          scriptureNotifer.verseRef = value;
        },
        inputFormatters: verseInputFormatters(max: scriptureNotifer.getVerseMax),
      ),
    );
  }
}
