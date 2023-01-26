import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import 'notifiers/media_center_photos_notifier.dart';
import 'notifiers/media_center_playlists_notifier.dart';
import 'notifiers/media_center_videos_notifier.dart';

//TODO make these async

final photosProvider = StateNotifierProvider.autoDispose<MediaCenterPhotosNotifier, List<File>>((ref) {
  return MediaCenterPhotosNotifier(photoThumbnailsDirectory());
});

final videosProvider = StateNotifierProvider.autoDispose<MediaCenterVideosNotifier, List<VideoData>>((ref) {
  return MediaCenterVideosNotifier(videosDirectory());
});

final playlistsProvider = StateNotifierProvider.autoDispose<MediaCenterPlaylistsNotifier, List<Playlist>>((ref) {
  return MediaCenterPlaylistsNotifier(playlistsDirectory(), songsDirectory());
});

final selectedPhotoProvider = StateProvider.autoDispose<Set<String>>((ref) {
  return {};
});

final mediaCenterCtrlKeyNotifier = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final selectedPlaylistProvider = StateProvider.autoDispose<String>((ref) {
  List<String> playlist = ref.watch(playlistsProvider).map((e) => e.fileName).toList();
  String currentPlaylist = ref.watch(activePlaylistProvider).fileName;

  if (playlist.isNotEmpty) {
    if (playlist.contains(currentPlaylist)) {
      return currentPlaylist;
    }

    return playlist.first;
  } else {
    return '';
  }
});
