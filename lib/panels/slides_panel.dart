import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/widgets/song_slide_widget.dart';

import '../models/slide_model.dart';

class SlidesPanel extends ConsumerWidget {
  const SlidesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Slide> slides = ref.watch(projectionSlidesProvider);

    return FocusScope(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (event) {
            if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
              ref.read(projectedSlideNotifier.notifier).up();
            }
            if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
              ref.read(projectedSlideNotifier.notifier).down();
            }
            if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              ref.read(projectedSlideNotifier.notifier).left();
            }
            if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              ref.read(projectedSlideNotifier.notifier).right();
            }
          },
          child: GridView.builder(
            itemCount: slides.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 50,
              crossAxisSpacing: 50,
              mainAxisExtent: 170,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ref.read(projectedSlideNotifier.notifier).click(index);
                },
                child: slides[index].slideType == SlideType.scripture
                    ? Card(
                        child: Center(
                          child: Text(
                            slides[index].text,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : SongSlideWidget(text: slides[index].text, ref: slides[index].reference!),
              );
            },
          ),
        ),
      ),
    );
  }
}
