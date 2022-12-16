import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/bible_reference_model.dart';

class BookAutocompleteField extends ConsumerWidget {
  const BookAutocompleteField({super.key});

  static final TextEditingController _textEditingController = TextEditingController();

  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> books = [];
    BibleReference bibleRef = ref.watch(bibleReferenceProvider);

    try {
      books = Map<String, int>.from(ref.watch(selectedTranslationDataProvider)!['books']).keys.toList();
    } catch (e) {
//
    }

    if (_textEditingController.text.isEmpty && bibleRef.book != null) {
      _textEditingController.text = bibleRef.book!;
    }

    _focusNode.addListener(
      () {
        if (!_focusNode.hasFocus) {
          if (_textEditingController.text != bibleRef.book) {
            ref.read(bibleReferenceProvider.notifier).updateChapter(1);
            _textEditingController.text = bibleRef.book ?? '';
          }
        }
      },
    );

    return SizedBox(
      width: 130,
      child: TypeAheadField(
        minCharsForSuggestions: 1,
        debounceDuration: const Duration(milliseconds: 200),
        textFieldConfiguration:
            TextFieldConfiguration(controller: _textEditingController, focusNode: _focusNode, enabled: bibleRef.translation != null),
        suggestionsCallback: ((pattern) {
          if (pattern == '') {
            return const Iterable<String>.empty();
          }

          String output = books.firstWhere(
            (String option) {
              return option.toLowerCase().startsWith(pattern.toLowerCase().trim());
            },
            orElse: () {
              return 'Genesis';
            },
          );

        
            ref.read(bibleReferenceProvider.notifier).updateBook(output);
        

          if (output == 'Genesis') return const Iterable<String>.empty();

          //hide suggestions if text is the same as suggestion
          if (output.toLowerCase() == _textEditingController.text.toLowerCase()) {
            return const Iterable<String>.empty();
          }

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
          if (suggestion == _textEditingController.text) return;
          _textEditingController.text = suggestion;
          ref.read(bibleReferenceProvider.notifier).updateChapter(1);
        }),
        hideOnEmpty: true,
        hideOnError: true,
      ),
    );
  }
}
