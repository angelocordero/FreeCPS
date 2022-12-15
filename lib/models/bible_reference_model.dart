class BibleReference {
  String? tag;
  String? translation;
  String? book;
  int? chapter;
  String? verse;

  int? _startVerse;
  int? _endVerse;

  BibleReference({
    this.tag,
    this.translation,
    this.book,
    this.chapter,
    this.verse,
  }) {
    if (verse == null) return;

    List<String> num = verse!.split('-');

    if (num.length == 2) {
      _startVerse = int.tryParse(num[0]);
      _endVerse = int.tryParse(num[1]);
    } else {
      _startVerse = int.tryParse(num[0]);
    }
  }

  @override
  bool operator ==(covariant BibleReference other) {
    if (identical(this, other)) return true;

    return other.tag == tag &&
        other.translation == translation &&
        other.book == book &&
        other.chapter == chapter &&
        other._startVerse == _startVerse &&
        other._endVerse == _endVerse;
  }

  @override
  int get hashCode {
    return tag.hashCode ^ translation.hashCode ^ book.hashCode ^ chapter.hashCode ^ _startVerse.hashCode ^ _endVerse.hashCode;
  }

  @override
  String toString() {
    return 'BibleReference(tag: $tag, translation: $translation, book: $book, chapter: $chapter, startVerse: $_startVerse, endVerse: $_endVerse)';
  }
}
