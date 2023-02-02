import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/slide_model.dart';
import '../../models/song_model.dart';
import '../../widgets/song_slide_widget.dart';

class SongSlidePreview extends StatelessWidget {
  const SongSlidePreview({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    List<Slide> slides = [];

    for (var entries in song.lyrics.entries) {
      String ref = entries.key;

      for (var element in entries.value) {
        slides.add(Slide(text: element, reference: ref, slideType: SlideType.song));
      }
    }

    return GridView.builder(
      itemCount: slides.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 50,
        crossAxisSpacing: 50,
        mainAxisExtent: 170,
      ),
      itemBuilder: (context, index) {
        return SongSlideWidget(
          text: slides[index].text,
          reference: slides[index].reference!,
          index: index,
        );
      },
    );
  }
}
