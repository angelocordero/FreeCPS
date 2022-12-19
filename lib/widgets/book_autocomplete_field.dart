import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/bible_reference_model.dart';
import 'package:freecps/notifiers/bible_reference_notifier.dart';

class BookAutocompleteField extends ConsumerWidget {
  const BookAutocompleteField({super.key});

  static final TextEditingController _controller = TextEditingController();

  static final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BibleReference bibleRef = ref.watch(bibleReferenceProvider);
    final BibleReferenceNotifier bibleRefNotifier = ref.watch(bibleReferenceProvider.notifier);

    _controller.text = bibleRef.book.toString();
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    _focusNode.addListener(
      () {
        if (!_focusNode.hasPrimaryFocus) {
          if (_controller.text != bibleRef.book) {
            bibleRefNotifier.bookRef = bibleRefNotifier.getBooks.firstWhere(
              (String option) {
                return option.toLowerCase().startsWith(_controller.text.toLowerCase().trim());
              },
              orElse: () {
                return '';
              },
            );
          }
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
          enabled: bibleRef.translation != null,
        ),
        suggestionsCallback: ((pattern) {
          if (pattern == '') {
            return const Iterable<String>.empty();
          }

          String output = bibleRefNotifier.getBooks.firstWhere(
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
        }),
        hideOnEmpty: true,
        hideOnError: true,
      ),
    );
  }
}
