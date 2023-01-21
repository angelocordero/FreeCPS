import 'package:freecps/core/constants.dart';

class Slide {
  String text;
  String? reference;
  SlideType slideType;

  Slide({
    required this.text,
    this.reference,
    required this.slideType,
  });

  @override
  String toString() => 'Slide(text: $text, reference: $reference)';

  @override
  bool operator ==(covariant Slide other) {
    if (identical(this, other)) return true;

    return other.text == text && other.reference == reference;
  }

  @override
  int get hashCode => text.hashCode ^ reference.hashCode;
}
