import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/widgets/projection_text_widget.dart';

import '../core/constants.dart';
import '../core/providers_declaration.dart';
import '../models/slide_model.dart';

/// Slide widget for songs in slide panel
class SongSlideWidget extends ConsumerWidget {
  const SongSlideWidget({super.key, required this.slide, required this.index, required this.scaleFactor});

  final int index;
  final SongSlide slide;
  final double scaleFactor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = catpuccinColorsSample[slide.reference] ?? Colors.blueGrey;

    int? selected = ref.watch(projectedSlideNotifier);

    return Card(
      shape: selected == index
          ? const RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff1e66f5),
                width: 1.5,
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ProjectionTextWidget(
              slide: slide,
              scaleFactor: scaleFactor,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              color: color,
              child: Text(
                slide.reference ?? '',
                style: const TextStyle(fontSize: 100),
                textScaleFactor: scaleFactor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
