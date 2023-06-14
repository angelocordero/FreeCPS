import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/slide_model.dart';

class ProjectionTextWidget extends StatelessWidget {
  const ProjectionTextWidget({super.key, required this.slide, this.scaleFactor});

  final Slide slide;
  final double? scaleFactor;

  @override
  Widget build(BuildContext context) {
    String? reference = slide is SongSlide ? null : (slide as ScriptureSlide).reference;

    String text = slide.text;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30.0 * (scaleFactor ?? 1)),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: slide is SongSlide
                      ? Text(
                          text,
                          maxLines: 10,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          style: songSlideTextStyle,
                          textScaleFactor: (scaleFactor ?? 1),
                        )
                      : Text(
                          text,
                          maxLines: 10,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          textScaleFactor: (scaleFactor ?? 1),
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
                    Text(
                      reference,
                      style: refTextStyle,
                      textScaleFactor: (scaleFactor ?? 1),
                    ),
                    SizedBox(
                      width: 50 * (scaleFactor ?? 1),
                    ),
                  ],
                ),
              SizedBox(
                height: 50 * (scaleFactor ?? 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
