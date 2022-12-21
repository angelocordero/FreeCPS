class Slide {
  String text;
  String? reference;

  Slide({
    required this.text,
    this.reference,
  });

  @override
  String toString() => 'Slide(text: $text, bibleRef: $reference)';

  @override
  bool operator ==(covariant Slide other) {
    if (identical(this, other)) return true;

    return other.text == text && other.reference == reference;
  }

  @override
  int get hashCode => text.hashCode ^ reference.hashCode;
}
