import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/file_utils.dart';
import '../core/projection_utils.dart';
import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';

class PlaylistMediaExpansionTile extends ConsumerWidget {
  const PlaylistMediaExpansionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Playlist playlist = ref.watch(activePlaylistProvider);

    return ExpansionTile(
      initiallyExpanded: true,
      title: const Text('Media'),
      children: [
        ...playlist.media.map(
          (media) {
            return GestureDetector(
              onTap: () async {
                try {
                  String filePath = '';

                  for (var element in videoFileExtensions) {
                    if (media.toLowerCase().contains(element)) {
                      filePath = await FileUtils.getVideoFilePath(media);
                    } 
                  }

                  for (var element in photoFileExtensions) {
                    if (media.toLowerCase().contains(element)) {
                      filePath = await FileUtils.getPhotoFilePath(media);
                    } 
                  }

                  bool isLive = ref.read(liveProvider);
                  await ProjectionUtils.setBackground(filePath, isLive);
                } catch (e) {
                  //
                }
              },
              child: Card(
                child: ListTile(
                  title: Text(media),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
