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

String formatDuration(Duration position) {
  final ms = position.inMilliseconds;

  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  final minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';

  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';

  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';

  final formattedTime = '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

  return formattedTime;
}

double calculateScaleOfSlides({required double mediaQueryWidth, required double projectionWindowWidth, required double slidesPanelWeight}) {
  double panelWidth = (mediaQueryWidth * slidesPanelWeight) - 40 - 5;

  double widthOfSlide = (panelWidth - 190 - 32) / 4;

  double slidesPanelToSlideScaleFactor = widthOfSlide / panelWidth;

  //double slidesPanelToSlideScaleFactor = 0.22009921089;
  double scaleFactor = mediaQueryWidth / projectionWindowWidth * slidesPanelWeight * slidesPanelToSlideScaleFactor;

  return scaleFactor;
}
