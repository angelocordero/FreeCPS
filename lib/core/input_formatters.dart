import 'package:flutter/services.dart';

List<TextInputFormatter> verseInputFormatters({
  required int max,
}) {
  return [
    FilteringTextInputFormatter(RegExp("[0-9-]"), allow: true),
    VerseInputFormatter(max),
  ];
}

List<TextInputFormatter> chapterInputFormatters({
  required int max,
}) {
  return [
    FilteringTextInputFormatter(RegExp("[0-9]"), allow: true),
    ChapterInputFormatter(max),
  ];
}

class ChapterInputFormatter extends TextInputFormatter {
  ChapterInputFormatter(this.max);

  final int max;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty || newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) > max) {
      return const TextEditingValue()
          .copyWith(text: max.toString(), selection: TextSelection.fromPosition(TextPosition(offset: max.toString().length)));
    } else {
      return newValue;
    }
  }
}

class VerseInputFormatter extends TextInputFormatter {
  VerseInputFormatter(this.max);

  final int max;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int? first;
    int? second;

    List<String> num = newValue.text.split('-');

    if (num.length > 1) {
      first = int.tryParse(num[0]);
      second = int.tryParse(num[1]);
    } else {
      first = int.tryParse(num[0]);
    }

    if (newValue.text.isEmpty || newValue.text == '') {
      return newValue;
    } else if (first != null && first > max && second == null) {
      return const TextEditingValue()
          .copyWith(text: max.toString(), selection: TextSelection.fromPosition(TextPosition(offset: max.toString().length)));
    } else if (first != null && second != null && second > max) {
      String output = '$first-$max';

      return const TextEditingValue().copyWith(text: output, selection: TextSelection.fromPosition(TextPosition(offset: output.length)));
    } else {
      return newValue;
    }
  }
}