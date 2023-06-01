import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/models/scripture_slide_model.dart';
import 'package:freecps/windows/projection_window.dart';

import '../core/providers_declaration.dart';
import '../models/slide_model.dart';
import '../models/song_slide_model.dart';
import '../widgets/projection_text_widget.dart';
import '../widgets/song_slide_widget.dart';

class SlidesPanel extends ConsumerWidget {
  const SlidesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Slide> slides = ref.watch(projectionSlidesProvider);
    FocusNode focusNode = FocusNode();

    return FocusScope(
      canRequestFocus: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: RawKeyboardListener(
          focusNode: focusNode,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ref.watch(slidePanelTitleProvider).isNotEmpty) Text(ref.watch(slidePanelTitleProvider)),
              if (ref.watch(slidePanelTitleProvider).isNotEmpty) const Divider(),
              Expanded(
                child: GridView.builder(
                  itemCount: slides.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 50,
                    crossAxisSpacing: 50,
                    childAspectRatio: slides.firstOrNull is SongSlide ? 16 / 10.675 : 16 / 9, // idk aboout 10.68 but it just works
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(projectedSlideNotifier.notifier).click(index);
                        focusNode.requestFocus();
                      },
                      child: slides[index] is ScriptureSlide
                          ? _ScriptureSlideWidget(
                              slide: slides[index] as ScriptureSlide,
                              index: index,
                            )
                          : SongSlideWidget(
                              text: slides[index].text,
                              reference: (slides[index] as SongSlide).reference!,
                              index: index,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Slide widget for scripture in slide panel
class _ScriptureSlideWidget extends ConsumerWidget {
  const _ScriptureSlideWidget({required this.slide, required this.index});

  final int index;
  final ScriptureSlide slide;

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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            slide.text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
