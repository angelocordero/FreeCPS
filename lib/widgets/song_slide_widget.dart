import 'package:flutter/material.dart';
import 'package:freecps/core/constants.dart';

class SongSlideWidget extends StatelessWidget {
  const SongSlideWidget({super.key, required this.text, required this.ref});

  final String text;
  final String ref;

  @override
  Widget build(BuildContext context) {
    final Color color = catpuccinColorsSample[ref] ?? Colors.blueGrey;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            color: color,
            child: Text(ref),
          ),
        ],
      ),
    );
  }
}
