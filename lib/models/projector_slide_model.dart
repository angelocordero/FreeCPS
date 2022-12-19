import 'bible_reference_model.dart';

class ProjectorSlide {
  ProjectorSlide.scripture({
    required this.text,
    required BibleReference bibleRef,
  });

  ProjectorSlide.song({
    required this.text,
  });

  String text;
  String? bibleRef;
}
