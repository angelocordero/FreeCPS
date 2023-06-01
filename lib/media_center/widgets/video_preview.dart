import 'package:flutter/material.dart';
import 'package:freecps/media_center/widgets/video_controls.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({super.key, required this.filePath});

  final String filePath;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    player = Player();
    controller = VideoController(
      player,
      configuration: const VideoControllerConfiguration(width: 1280, height: 720),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    player.open(Media(widget.filePath), play: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Video(
            controller: controller,
            height: 720,
            width: 1280,
          ),
        ),
        VideoControls(player: player),
      ],
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
