class ScriptureModel {
  ScriptureModel({
    this.translation,
    this.book,
    this.chapter,
    this.verse,
    this.verses,
  }) {
    if (verse == null) return;

    if (verse!.isEmpty) return;

    List<String> num = verse!.split('-');

    startVerse = int.tryParse(num[0]) ?? 1;
    if (num.length == 2) {
      endVerse = int.tryParse(num[1]);
    }
  }

  String? book;
  int? chapter;
  int? endVerse;
  String name = '';
  int? startVerse;
  String? translation;
  String? verse;
  List<Map>? verses;

  @override
  bool operator ==(covariant ScriptureModel other) {
    if (identical(this, other)) return true;

    return other.translation == translation &&
        other.book == book &&
        other.chapter == chapter &&
        other.startVerse == startVerse &&
        other.endVerse == endVerse;
  }

  @override
  int get hashCode {
    return name.hashCode ^ translation.hashCode ^ book.hashCode ^ chapter.hashCode ^ startVerse.hashCode ^ endVerse.hashCode;
  }

  @override
  String toString() {
    return 'ScriptureModel(name: $name, translation: $translation, book: $book, chapter: $chapter, verse: $verse, startVerse: $startVerse, endVerse: $endVerse)';
  }

  ScriptureModel copyWith({
    String? translation,
    String? book,
    int? chapter,
    String? verse,
    List<Map>? verses,
  }) {
    return ScriptureModel(
      translation: translation ?? this.translation,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      verses: verses ?? this.verses,
    );
  }
}
