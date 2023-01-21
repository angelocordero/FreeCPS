import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecps/widgets/projection_text_slide_widget.dart';
import 'package:window_manager/window_manager.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(Colors.black12, BlendMode.darken),
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
  void initState() {
    player = Player(id: 1);
    player.setPlaylistMode(PlaylistMode.loop);

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
        } else if (call.method == 'showSlide') {
          List<String> args = (call.arguments as String).split('<split>');

          if (args.length == 1) {
            showNextSlide(args.first, '');
            return;
          }

          showNextSlide(
            args[0],
            args[1],
          );
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    windowManager.close();
    super.dispose();
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

  void showNextSlide(String text, String reference) {
    setState(() {
      if (showingFirst) {
        second = ProjectionSlideTextWidget(
          text: text,
          reference: reference,
        );
      } else {
        first = ProjectionSlideTextWidget(
          text: text,
          reference: reference,
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
