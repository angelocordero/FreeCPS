import 'package:flutter/material.dart';

import '../widgets/book_autocomplete_field.dart';
import '../widgets/chapter_field.dart';
import '../widgets/translation_picker.dart';
import '../widgets/verse_field.dart';

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
                      TranslationPicker(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Book'),
                      SizedBox(
                        width: 20,
                      ),
                      BookAutocompleteField(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Chapter'),
                      SizedBox(
                        width: 20,
                      ),
                      ChapterField(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
      ),
    );
  }
}
