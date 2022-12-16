class BibleReference {
  String? translation;
  String? book;
  int? chapter;
  String? verse;

  int? startVerse;
  int? endVerse;
  String name = '';

  BibleReference({
    this.translation,
    this.book,
    this.chapter,
    this.verse,
  }) {
    if (verse == null) return;

    if (verse!.isEmpty) return;

    List<String> num = verse!.split('-');

    startVerse = int.tryParse(num[0]) ?? 1;
    if (num.length == 2) {
      endVerse = int.tryParse(num[1]);
    }
  }

  @override
  bool operator ==(covariant BibleReference other) {
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
    return 'BibleReference(name: $name, translation: $translation, book: $book, chapter: $chapter, verse: $verse)';
  }

  BibleReference copyWith({
    String? translation,
    String? book,
    int? chapter,
    String? verse,
  }) {
    return BibleReference(
      translation: translation ?? this.translation,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
    );
  }

  bool get isValid {
    if (translation == null && book == null && chapter == null && startVerse == null) return false;

    if (endVerse != null) {
      return translation!.isNotEmpty && book!.isNotEmpty && chapter! >= 1 && startVerse! >= 1 && endVerse! > startVerse!;
    }

    return translation!.isNotEmpty && book!.isNotEmpty && chapter! >= 1 && startVerse! >= 1;
  }
}
