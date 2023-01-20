import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';

import '../models/slide_model.dart';

class SlidesPanel extends ConsumerWidget {
  const SlidesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Slide> slides = ref.watch(projectionSlidesProvider);

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
          return GestureDetector(
            onTap: () async {
              ref.read(projectedSlideNotifier.notifier).project(index, slides[index]);
            },
            child: Card(
              child: Center(
                child: Text(
                  slides[index].text,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
