import 'package:flutter/material.dart';

class ProjectionSlideTextWidget extends StatelessWidget {
  const ProjectionSlideTextWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 1080,
      width: 1920,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
