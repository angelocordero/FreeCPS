import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';
import 'package:freecps/core/helper_functions.dart';
import 'package:freecps/media_center/widgets/song_preview.dart';
import 'package:path/path.dart';

import '../../models/saved_verse_slides.dart';
import '../../models/song_model.dart';

class MediaCenterPlaylistPreviewNotifier extends StateNotifier<Widget> {
  MediaCenterPlaylistPreviewNotifier(dynamic args) : super(Container()) {
    _preview(args);
  }

  void _preview(dynamic args) {
    if (args is Song) {
      _previewSong(args);
    } else if (args is SavedVerseSlides) {
      _previewVerses(args);
    } else if (args is String) {
      _previewMedia(args);
    } else {
      state = Container();
    }
  }

  void _previewMedia(String args) async {
    for (var e in photoFileExtensions) {
      if (args.toLowerCase().contains(e)) {
        String filePath = join(await photosDirectory(), args);

        state = Image.file(File(filePath));
        return;
      }
    }

    for (var e in videoFileExtensions) {
      if (args.toLowerCase().contains(e)) {
        //String filePath = join(await videosDirectory(), args);

        // TODO show thumbnail
        state = const Center(
          child: Text('Video Preview is currently not supported\n https://github.com/alexmercerind/dart_vlc/issues/357'),
        );
        //state = VideoPreview(filePath: filePath);

        return;
      }
    }
  }

  void _previewVerses(SavedVerseSlides args) {
    state = ListView(
      children: [
        Text(scriptureRefToRefString(args.scriptureRef)),
        const Divider(
          height: 30,
        ),
        ...args.verseSlides.map(
          (e) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e.text),
              const Divider(
                height: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _previewSong(Song args) {
    state = SongPreview(song: args);
  }
}
