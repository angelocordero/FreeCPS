// import 'package:flutter/material.dart';
// import '../projector_layers/media_layer.dart';
// import '../projector_layers/slide_layer.dart';

// class ProjectorWindow extends StatelessWidget {
//   const ProjectorWindow({super.key});

//   @override
//   Widget build(BuildContext context) {
   
//     return MaterialApp(
//       debugShowCheckedModeBanner: true,
//       theme: ThemeData.dark(),
//       home: Scaffold(
//         body: SizedBox.expand(
//           child: Stack(
//             children: const [
//               MediaLayer(),
//               SlideLayer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class ProjectorWindow extends StatefulWidget {
  const ProjectorWindow({super.key});

  @override
  State<ProjectorWindow> createState() => _ProjectorWindowState();
}

class _ProjectorWindowState extends State<ProjectorWindow> {
  late final Player player;

  Widget first = Container();
  Widget second = Container();

  bool showingFirst = false;

  @override
  void initState() {

    player = Player(id: 1);
    player.setPlaylistMode(PlaylistMode.loop);

    DesktopMultiWindow.setMethodHandler(
      (call, _) async {
        if (call.method == 'setBackground' && call.arguments is String) {
          if (call.arguments == '' || call.arguments == null) return;

          Media file = Media.file(
            File(call.arguments),
          );

          player.open(file);
        } else if (call.method == 'clearBackground') {
          Media file = Media.file(
            File('/home/angelo/Dev/Flutter/multi_window_test/media/black.jpg'),
          );

          player.open(file);
        } else if (call.method == 'close') {
          dispose();
        } else if (call.method == 'showVerse') {
          //
        } else if (call.method == 'verseSlide') {
          setState(() {
             if (showingFirst) {
            second = Container(
              color: Colors.transparent,
              height: 1080,
              width: 1920,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
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
              ),
            );
          } else {
            first = Container(
              color: Colors.transparent,
              height: 1080,
              width: 1920,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
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
              ),
            );
          }

          showingFirst = !showingFirst;
          });
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              Video(
                player: player,
                fit: BoxFit.cover,

                scale: 1.0, // default
                showControls: false, // default
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
    player.dispose();
    windowManager.close();
    super.dispose();
  }
}

