import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import 'notifiers/media_center_bibles_notifier.dart';
import 'notifiers/media_center_photos_notifier.dart';
import 'notifiers/media_center_playlist_preview_notifier.dart';
import 'notifiers/media_center_playlists_notifier.dart';
import 'notifiers/media_center_videos_notifier.dart';
import 'notifiers/media_center_songs_notifier.dart';

//TODO make these async

final photosProvider = StateNotifierProvider.autoDispose<MediaCenterPhotosNotifier, List<File>>((ref) {
  return MediaCenterPhotosNotifier(ref.watch(directoriesProvider)['photoThumbnailsDir']!);
});

final videosProvider = StateNotifierProvider.autoDispose<MediaCenterVideosNotifier, List<File>>((ref) {
  return MediaCenterVideosNotifier(ref.watch(directoriesProvider)['videosDir']!);
});

final playlistsProvider = StateNotifierProvider.autoDispose<MediaCenterPlaylistsNotifier, List<Playlist>>((ref) {
  Map<String, String> dirs = ref.watch(directoriesProvider);

  return MediaCenterPlaylistsNotifier(dirs['playlistDir']!, dirs['songsDir']!);
});

final songsProvider = StateNotifierProvider.autoDispose<MediaCenterSongsNotifier, List<Song>>((ref) {
  return MediaCenterSongsNotifier(ref.watch(directoriesProvider)['songsDir']!);
});

final biblesProvider = StateNotifierProvider.autoDispose<MediaCenterBiblesNotifier, List<BibleData>>((ref) {
  return MediaCenterBiblesNotifier(ref.watch(directoriesProvider)['biblesDir']!);
});

final mediaCenterCtrlKeyNotifier = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final selectedPhotoProvider = StateProvider.autoDispose<Set<String>>((ref) {
  return {};
});

final selectedVideoProvider = StateProvider.autoDispose<Set<String>>((ref) {
  return {};
});

final selectedSongProvider = StateProvider.autoDispose<Song>((ref) {
  List<Song> songs = ref.watch(songsProvider);

  if (songs.isEmpty) {
    return Song.empty();
  }

  return songs.first;
});

final previewedPlaylistProvider = StateProvider.autoDispose<Playlist>((ref) {
  List<Playlist> playlist = ref.watch(playlistsProvider);
  Playlist currentPlaylist = ref.watch(activePlaylistProvider);

  if (playlist.isNotEmpty) {
    if (playlist.map((e) => e.fileName).contains(currentPlaylist.fileName)) {
      return currentPlaylist;
    }

    return playlist.first;
  } else {
    return Playlist.empty();
  }
});

final playlistPreviewProvider = StateNotifierProvider.autoDispose<MediaCenterPlaylistPreviewNotifier, Widget>((ref) {
  dynamic selected = ref.watch(playlistPreviewSelectedObjectProvider);

  return MediaCenterPlaylistPreviewNotifier(args: selected, photosDir: ref.watch(directoriesProvider)['photosDir']!);
});

final playlistPreviewSelectedObjectProvider = StateProvider.autoDispose<dynamic>((ref) {
  List<Song> songs = ref.watch(previewedPlaylistProvider.select((value) => value.songs));
  if (songs.isNotEmpty) {
    return songs.first;
  }

  return null;
});
