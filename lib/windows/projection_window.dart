import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecps/models/scripture_slide_model.dart';
import 'package:window_manager/window_manager.dart';

import '../core/constants.dart';
import '../models/slide_model.dart';
import '../models/song_slide_model.dart';

class ProjectionWindow extends StatefulWidget {
  const ProjectionWindow({super.key});

  @override
  State<ProjectionWindow> createState() => _ProjectionWindowState();
}

class _ProjectionWindowState extends State<ProjectionWindow> {
  Widget first = Container();
  late final Player player;
  Widget second = Container();
  bool showingFirst = false;

  bool focused = false;

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
                  player: player,
                  fit: BoxFit.cover,
                  showControls: false,
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

    player = Player(id: 9999);
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
    Media file = Media.asset('media/black.jpg');
    player.open(file);
  }

  void setBackground(MethodCall call) {
    if (call.arguments == '' || call.arguments == null) return;

    Media file = Media.file(
      File(call.arguments),
    );
    player.open(file);
  }

  void showNextSlide(Slide slide) {
    setState(() {
      if (showingFirst) {
        second = _ProjectionTextWidget(
          slide: slide,
        );
      } else {
        first = _ProjectionTextWidget(
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

class _ProjectionTextWidget extends StatelessWidget {
  const _ProjectionTextWidget({required this.slide});

  final Slide slide;

  @override
  Widget build(BuildContext context) {
    String? reference = slide is SongSlide ? null : (slide as ScriptureSlide).reference;

    String text = slide.text;

    return Container(
      color: Colors.transparent,
      height: 1080,
      width: 1920,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: slide is SongSlide
                    ? Text(text, maxLines: 10, softWrap: true, textAlign: TextAlign.center, overflow: TextOverflow.fade, style: songSlideTextStyle)
                    : Text(
                        text,
                        maxLines: 10,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontFamily: 'SegoeUI',
                          fontSize: 80,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            if (reference != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(reference, style: refTextStyle),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
