import 'package:flutter/painting.dart';

import '../models/scripture_reference_model.dart';

String scriptureRefToRefString(ScriptureReference ref) {
  return '${ref.translation} ${ref.book} ${ref.chapter}:${ref.verse!.verseString}';
}

//TODO refactor
int maxCharacters(
  String text,
  TextStyle style,
) {
  final TextPainter heightPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);

  final TextPainter widthPainter = TextPainter(
    // M as text because it probably is the widest
    text: TextSpan(text: 'M', style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);

  double height = heightPainter.height;
  double paddingSize = 30;
  int maxLines = (1080 - (2 * paddingSize) - 100) ~/ height;

  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: 1920 - 30 - 30);

  return ((textPainter.width ~/ widthPainter.width) * maxLines) - 5;
}
