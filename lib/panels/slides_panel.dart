import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/models/projector_slide_model.dart';

class SlidesPanel extends ConsumerWidget {
  const SlidesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<ProjectorSlide> slides = ref.watch(projectorSlidesProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        itemCount: slides.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          mainAxisExtent: 150,
        ),
        itemBuilder: (context, index) {
          return Card(
            child: Center(
              child: Text(
                slides[index].text,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
