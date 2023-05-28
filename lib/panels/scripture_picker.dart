import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../core/input_formatters.dart';
import '../core/providers_declaration.dart';
import '../models/scripture_model.dart';
import '../notifiers/scripture_notifier.dart';

class ScripturePickerPanel extends StatelessWidget {
  const ScripturePickerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const FocusScope(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SCRIPTURE',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Divider(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Translation: '),
                      SizedBox(
                        width: 20,
                      ),
                      _TranslationPicker(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Book'),
                      SizedBox(
                        width: 20,
                      ),
                      _BookAutocompleteField(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Chapter'),
                      SizedBox(
                        width: 20,
                      ),
                      _ChapterField(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Verse'),
                      SizedBox(
                        width: 20,
                      ),
                      _VerseField(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TranslationPicker extends ConsumerWidget {
  const _TranslationPicker({Key? key}) : super(key: key);

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

class _VerseField extends ConsumerWidget {
  const _VerseField();

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);
    ScriptureNotifier scriptureNotifer = ref.watch(scriptureProvider.notifier);

    _controller.text = scripture.scriptureRef.verse?.toDisplayString() ?? '';
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

class _ChapterField extends ConsumerWidget {
  const _ChapterField();

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Scripture scripture = ref.watch(scriptureProvider);
    ScriptureNotifier scriptureNotifier = ref.watch(scriptureProvider.notifier);

    if (scripture.scriptureRef.chapter == null) {
      _controller.text = '';
    } else {
      _controller.text = scripture.scriptureRef.chapter.toString();
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }

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

class _BookAutocompleteField extends ConsumerWidget {
  const _BookAutocompleteField();

  static final TextEditingController _controller = TextEditingController();
  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Scripture scripture = ref.watch(scriptureProvider);
    final ScriptureNotifier scriptureNotifier = ref.watch(scriptureProvider.notifier);

    if (scripture.scriptureRef.book == null) {
      _controller.text = '';
    } else {
      _controller.text = scripture.scriptureRef.book.toString();
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }

    _focusNode.addListener(
      () {
        if (!_focusNode.hasFocus) {
          if (_controller.text.toLowerCase() == scripture.scriptureRef.book.toString().toLowerCase()) return;
          scriptureNotifier.bookRef = scriptureNotifier.getBooks.firstWhere(
            (String option) {
              return option.toLowerCase().startsWith(_controller.text.toLowerCase().trim());
            },
            orElse: () {
              return '';
            },
          );
        }
        if (_focusNode.hasPrimaryFocus) {
          _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
        }
      },
    );

    return SizedBox(
      width: 130,
      child: TypeAheadField(
        minCharsForSuggestions: 1,
        debounceDuration: const Duration(milliseconds: 200),
        textFieldConfiguration: TextFieldConfiguration(
          controller: _controller,
          focusNode: _focusNode,
          enabled: scripture.scriptureRef.translation != null,
        ),
        suggestionsCallback: ((pattern) {
          if (pattern == '') {
            return const Iterable<String>.empty();
          }

          String output = scriptureNotifier.getBooks.firstWhere(
            (String option) {
              return option.toLowerCase().startsWith(pattern.toLowerCase().trim());
            },
            orElse: () {
              return '';
            },
          );

          if (output == '') return const Iterable<String>.empty();

          return [output];
        }),
        itemBuilder: ((context, itemData) {
          return ListTile(
            title: Text(itemData),
            visualDensity: VisualDensity.compact,
            dense: true,
          );
        }),
        onSuggestionSelected: ((suggestion) {}),
        hideOnEmpty: true,
        hideOnError: true,
      ),
    );
  }
}
