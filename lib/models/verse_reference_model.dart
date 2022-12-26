import '../core/typedefs.dart';

class VerseReference {
  String verseString = '1';
  VerseRange verseRange = const VerseRange(1, null);
  VerseReference({
    required this.verseString,
  }) {
    List<String> num = verseString.split('-');

    if (num.length == 2) {
      verseRange = VerseRange(int.parse(num[0]), int.tryParse(num[1]));
      return;
    }

    verseRange = VerseRange(int.parse(num[0]), null);
  }

  VerseReference.defaultVerse() {
    verseRange = const VerseRange(1, null);
  }

  VerseReference copyWith({
    String? verseString,
  }) {
    return VerseReference(
      verseString: verseString ?? this.verseString,
    );
  }

  @override
  String toString() => verseString;

  @override
  bool operator ==(covariant VerseReference other) {
    if (identical(this, other)) return true;

    return other.verseString == verseString;
  }

  @override
  int get hashCode => verseString.hashCode;
}
