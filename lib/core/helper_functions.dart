import 'package:flutter/painting.dart';
import 'package:nanoid/nanoid.dart';

import '../models/scripture_reference_model.dart';
import 'constants.dart';

String scriptureRefToString(ScriptureReference ref) {
  return '${ref.translation} ${ref.book} ${ref.chapter}:${ref.verse!.verseString}';
}

String generateRandomID() {
  return customAlphabet(customIdAlphabet, 30);
}

//TODO refactor
int maxCharacters(
  String text,
  TextStyle style,
) {
  final TextPainter sizePainter = TextPainter(
    // M as text because it probably is the widest
    text: TextSpan(text: 'M', style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);

  double paddingSize = 30;
  int maxLines = (1080 - (2 * paddingSize) - 100) ~/ sizePainter.height;

  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: 1920 - 30 - 30);

  return ((textPainter.width ~/ sizePainter.width) * maxLines) - 5;
}
