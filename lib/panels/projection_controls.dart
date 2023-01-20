import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/projection_utils.dart';
import 'package:freecps/core/providers_declaration.dart';

class ProjectionControls extends ConsumerWidget {
  const ProjectionControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              ref.read(projectedSlideNotifier.notifier).clearSlide();
            },
            child: const Text('Clear Slide'),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () async {
              ProjectionUtils.clearBackground();
            },
            child: const Text('Clear Background'),
          ),
        ],
      ),
    );
  }
}
