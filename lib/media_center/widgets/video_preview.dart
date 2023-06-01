import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPreview extends StatelessWidget {
  const VideoPreview({super.key, required this.filePath});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    final Player player = Player();
    final VideoController controller = VideoController(player, configuration: const VideoControllerConfiguration(width: 1280, height: 720));

    player.setPlaylistMode(PlaylistMode.loop);
    player.open(Media(filePath));

    return AspectRatio(
      aspectRatio: 1280 / 720,
      child: Video(
        controller: controller,
        height: 720,
        width: 1280,
      ),
    );
  }
}
