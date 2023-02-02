import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import 'notifiers/bibles_notifier.dart';
import 'notifiers/media_center_photos_notifier.dart';
import 'notifiers/media_center_playlist_preview_notifier.dart';
import 'notifiers/media_center_playlists_notifier.dart';
import 'notifiers/media_center_videos_notifier.dart';
import 'notifiers/songs_notifier.dart';

//TODO make these async

final photosProvider = StateNotifierProvider.autoDispose<MediaCenterPhotosNotifier, List<File>>((ref) {
  return MediaCenterPhotosNotifier(photoThumbnailsDirectory());
});

final videosProvider = StateNotifierProvider.autoDispose<MediaCenterVideosNotifier, List<File>>((ref) {
  return MediaCenterVideosNotifier(videosDirectory());
});

final playlistsProvider = StateNotifierProvider.autoDispose<MediaCenterPlaylistsNotifier, List<Playlist>>((ref) {
  return MediaCenterPlaylistsNotifier(playlistsDirectory(), songsDirectory());
});

final songsProvider = StateNotifierProvider.autoDispose<SongsNotifier, List<Song>>((ref) {
  return SongsNotifier(songsDirectory());
});

final biblesProvider = StateNotifierProvider.autoDispose<BiblesNotifier, List<BibleData>>((ref) {
  return BiblesNotifier(biblesDirectory());
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

  return MediaCenterPlaylistPreviewNotifier(selected);
});

final playlistPreviewSelectedObjectProvider = StateProvider.autoDispose<dynamic>((ref) {
  List<Song> songs = ref.read(previewedPlaylistProvider.select((value) => value.songs));
  if (songs.isNotEmpty) {
    return songs.first;
  }

  return null;
});
