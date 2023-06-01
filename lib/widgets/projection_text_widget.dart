import 'package:flutter/material.dart';
import 'package:freecps/models/scripture_slide_model.dart';

import '../core/constants.dart';
import '../models/slide_model.dart';
import '../models/song_slide_model.dart';

class ProjectionTextWidget extends StatelessWidget {
  const ProjectionTextWidget({super.key, required this.slide});

  final Slide slide;

  @override
  Widget build(BuildContext context) {
    String? reference = slide is SongSlide ? null : (slide as ScriptureSlide).reference;

    String text = slide.text;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: slide is SongSlide
                      ? Text(text, maxLines: 10, softWrap: true, textAlign: TextAlign.center, overflow: TextOverflow.fade, style: songSlideTextStyle)
                      : Text(
                          text,
                          maxLines: 10,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontFamily: 'SegoeUI',
                            fontSize: 80,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              if (reference != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(reference, style: refTextStyle),
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
