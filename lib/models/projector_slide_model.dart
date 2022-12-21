import 'scripture_reference_model.dart';

class ProjectorSlide {
  ProjectorSlide.scripture({
    required this.text,
    required ScriptureReference bibleRef,
  });

  ProjectorSlide.song({
    required this.text,
  });

  String text;
  String? bibleRef;
}
