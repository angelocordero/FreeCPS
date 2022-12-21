import 'package:flutter/material.dart';

import '../models/slide_model.dart';

// TODO needs to be redone

class ProjectorSlideWidget extends StatelessWidget {
  const ProjectorSlideWidget({
    super.key,
    required this.slide,
  });

  final Slide slide;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1080,
      width: 1920,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              slide.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              slide.reference.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
