import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';
import 'package:freecps/core/helper_functions.dart';
import 'package:freecps/media_center/widgets/song_preview.dart';
import 'package:path/path.dart';

import '../../models/saved_verse_slides.dart';
import '../../models/song_model.dart';
import '../widgets/video_preview.dart';

class PlaylistPreviewPanelNotifier extends StateNotifier<Widget> {
  PlaylistPreviewPanelNotifier({required dynamic args, required this.photosDir}) : super(Container()) {
    _preview(args);
  }

  String photosDir;

  void _preview(dynamic args) {
    if (args is Song) {
      _previewSong(args);
    } else if (args is SavedVerseSlides) {
      _previewVerses(args);
    } else if (args is String) {
      _previewMedia(args);
    }
  }

  Future<void> _previewMedia(String args) async {
    for (var e in photoFileExtensions) {
      if (args.toLowerCase().contains(e)) {
        String filePath = join(photosDir, args);
        state = Image.file(File(filePath));
        return;
      }
    }

    for (var e in videoFileExtensions) {
      if (args.toLowerCase().contains(e)) {
        String filePath = join(await videosDirectory(), args);

        // TODO show thumbnail

        state = VideoPreview(filePath: filePath);

        return;
      }
    }
  }

  void _previewVerses(SavedVerseSlides args) {
    state = ListView(
      children: [
        Text(scriptureRefToString(args.scriptureRef)),
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
