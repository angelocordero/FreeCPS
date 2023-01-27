import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers_declaration.dart';


/// Slide widget for scripture in slide panel
class ScriptureSlideWidget extends ConsumerWidget {
  const ScriptureSlideWidget({super.key, required this.text, required this.index});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
