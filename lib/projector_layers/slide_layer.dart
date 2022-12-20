import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class SlideLayer extends StatefulWidget {
  const SlideLayer({super.key});

  @override
  State<SlideLayer> createState() => _SlideLayerState();
}

class _SlideLayerState extends State<SlideLayer> {
  Widget first = Container();
  Widget second = Container();

  bool showingFirst = false;

  @override
  void initState() {
    DesktopMultiWindow.setMethodHandler((call, _) async {
      if (call.method == 'verseSlide') {
        setState(() {
          if (showingFirst) {
            second = SizedBox(
              height: 1080,
              width: 1920,
              child: Center(
                child: Text(
                  call.arguments.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          } else {
            first = SizedBox(
              height: 1080,
              width: 1920,
              child: Center(
                child: Text(
                  call.arguments.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }

          showingFirst = !showingFirst;
        });
      }

      if (call.method == 'close') {
        dispose();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      alignment: Alignment.center,
      firstChild: first,
      secondChild: second,
      crossFadeState: showingFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
      sizeCurve: Curves.linear,
    );
  }

  @override
  void dispose() {
    windowManager.close();
    super.dispose();
  }
}
