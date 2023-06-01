import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecps/models/scripture_slide_model.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:window_manager/window_manager.dart';

import '../models/slide_model.dart';
import '../models/song_slide_model.dart';
import '../widgets/projection_text_widget.dart';

class ProjectionWindow extends StatefulWidget {
  const ProjectionWindow({super.key});

  @override
  State<ProjectionWindow> createState() => _ProjectionWindowState();
}

class _ProjectionWindowState extends State<ProjectionWindow> {
  Widget first = Container();
  Widget second = Container();

  bool showingFirst = false;
  bool focused = false;

  late final player = Player();
  late final controller = VideoController(player);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: focused
            ? FloatingActionButton(
                onPressed: () {
                  DesktopMultiWindow.invokeMethod(0, 'close');
                  //dispose();
                },
                child: const Icon(
                  Icons.close,
                ),
              )
            : null,
        body: SizedBox.expand(
          child: Stack(
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
                child: Video(
                  controller: controller,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: AnimatedCrossFade(
                  firstChild: first,
                  secondChild: second,
                  crossFadeState: showingFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    windowManager.close();
  }

  @override
  void initState() {
    super.initState();

    player.setPlaylistMode(PlaylistMode.loop);

    WidgetsBinding.instance.addPersistentFrameCallback((_) async {
      try {
        bool focus = await windowManager.isFocused();
        if (mounted) {
          setState(() {
            focused = focus;
          });
        }
      } catch (e) {
        //
      }
    });

    DesktopMultiWindow.setMethodHandler(
      (call, _) async {
        if (call.method == 'setBackground' && call.arguments is String) {
          setBackground(call);
        } else if (call.method == 'clearBackground') {
          clearBackground();
        } else if (call.method == 'clearSlide') {
          clearSlide();
        } else if (call.method == 'close') {
          dispose();
        } else if (call.method == 'showScriptureSlide') {
          showNextSlide(ScriptureSlide.fromJson(call.arguments as String));
        } else if (call.method == 'showSongSlide') {
          showNextSlide(SongSlide.fromJson(call.arguments as String));
        }
      },
    );
  }

  void clearBackground() {
    Media file = Media('media/black.jpg');
    player.open(file);
  }

  void setBackground(MethodCall call) {
    if (call.arguments == '' || call.arguments == null) return;

    Media file = Media(
      call.arguments,
    );
    player.open(file);
  }

  void showNextSlide(Slide slide) {
    setState(() {
      if (showingFirst) {
        second = ProjectionTextWidget(
          slide: slide,
        );
      } else {
        first = ProjectionTextWidget(
          slide: slide,
        );
      }

      showingFirst = !showingFirst;
    });
  }

  void clearSlide() {
    setState(() {
      if (showingFirst) {
        second = Container();
      } else {
        first = Container();
      }

      showingFirst = !showingFirst;
    });
  }
}


