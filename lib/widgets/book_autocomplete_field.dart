import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/scripture_model.dart';
import 'package:freecps/notifiers/scripture_model_notifier.dart';

import '../models/bible_reference_model.dart';

class BookAutocompleteField extends ConsumerWidget {
  const BookAutocompleteField({super.key});

  static final TextEditingController _controller = TextEditingController();

  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScriptureModel scripture = ref.watch(scriptureModelProvider);
    final ScriptureModelNotifier scriptureNotifier = ref.watch(scriptureModelProvider.notifier);

    _controller.text = scripture.book.toString();
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    _focusNode.addListener(
      () {
        if (!_focusNode.hasFocus) {
          if (_controller.text.toLowerCase() == scripture.book.toString().toLowerCase()) return;
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
          enabled: scripture.translation != null,
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
        onSuggestionSelected: ((suggestion) {
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
        }),
        hideOnEmpty: true,
        hideOnError: true,
      ),
    );
  }
}
