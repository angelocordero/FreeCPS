import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/providers_declaration.dart';


/// Slide widget for songs in slide panel
class SongSlideWidget extends ConsumerWidget {
  const SongSlideWidget({super.key, required this.text, required this.reference, required this.index});

  final int index;
  final String reference;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = catpuccinColorsSample[reference] ?? Colors.blueGrey;

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
            child: Text(reference),
          ),
        ],
      ),
    );
  }
}
