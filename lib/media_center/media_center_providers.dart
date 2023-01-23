import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../models/playlist_model.dart';
import 'notifiers/media_center_photos_notifier.dart';
import 'notifiers/media_center_playlists_notifier.dart';
import 'notifiers/media_center_videos_notifier.dart';

final photosProvider = StateNotifierProvider.autoDispose<MediaCenterPhotosNotifier, List<File>>((ref) {
  return MediaCenterPhotosNotifier(photoThumbnailsDirectory());
});

final videosProvider = StateNotifierProvider.autoDispose<MediaCenterVideosNotifier, List<VideoData>>((ref) {
  return MediaCenterVideosNotifier(videosDirectory());
});

final playlistsProvider = StateNotifierProvider.autoDispose<MediaCenterPlaylistsNotifier, List<Playlist>>((ref) {
  return MediaCenterPlaylistsNotifier(playlistsDirectory(), songsDirectory());
});
