import 'package:flutter/material.dart';
import 'package:freecps/widgets/chapter_field.dart';
import 'package:freecps/widgets/verse_field.dart';

import '../widgets/book_autocomplete_field.dart';
import '../widgets/translation_picker.dart';

class ScripturePickerPanel extends StatelessWidget {
  const ScripturePickerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'SCRIPTURE',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Translation: '),
                    SizedBox(
                      width: 20,
                    ),
                    TranslationPicker(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Book'),
                    SizedBox(
                      width: 20,
                    ),
                    BookAutocompleteField(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Chapter'),
                    SizedBox(
                      width: 20,
                    ),
                    ChapterField(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Verse'),
                    SizedBox(
                      width: 20,
                    ),
                    VerseField(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
