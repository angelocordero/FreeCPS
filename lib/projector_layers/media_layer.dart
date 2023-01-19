// import 'dart:io';

// import 'package:dart_vlc/dart_vlc.dart';
// import 'package:desktop_multi_window/desktop_multi_window.dart';
// import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';
// import '../core/constants.dart' as constants;

// class MediaLayer extends StatefulWidget {
//   const MediaLayer({super.key});

//   @override
//   State<MediaLayer> createState() => _MediaLayerState();
// }

// class _MediaLayerState extends State<MediaLayer> {
//   late final Player player;

//   @override
//   void initState() {
//     super.initState();
//     player = Player(id: 1);
//     player.setPlaylistMode(PlaylistMode.loop);

//     DesktopMultiWindow.setMethodHandler((call, _) async {
//       if (call.method == 'setBackground') {
//         player.open(Media.file(File(call.arguments)));
//       }

//       if (call.method == 'clearBackground') {
//         player.open(Media.file(File(constants.blackBackgroundFilePath)));
//       }
//       if (call.method == 'close') {
//         dispose();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Video(
//       player: player,
//       fit: BoxFit.cover,
//       showControls: false,
//     );
//   }

//   @override
//     void dispose() {
//     player.dispose();
//     super.dispose();
//     windowManager.close();
//   }
// }
