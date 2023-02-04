import 'dart:io';
import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({super.key, required this.filePath});

  final String filePath;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late Player player;

  @override
  void initState() {
    player = Player(id: Random().nextInt(999));
    player.setPlaylistMode(PlaylistMode.loop);
    player.open(Media.file(File(widget.filePath)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1280 / 720,
      child: Video(
        player: player,
        height: 720,
        width: 1280,
        showControls: false,
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
