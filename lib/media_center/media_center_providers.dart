import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers_declaration.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import 'notifiers/bibles_notifier.dart';
import 'notifiers/photos_notifier.dart';
import 'notifiers/playlists_notifier.dart';
import 'notifiers/videos_notifier.dart';
import 'notifiers/songs_notifier.dart';

//TODO make these async

final photosProvider = StateNotifierProvider.autoDispose<PhotosNotifier, List<File>>((ref) {
  return PhotosNotifier(ref.watch(directoriesProvider)['photoThumbnailsDir']!);
});

final videosProvider = StateNotifierProvider.autoDispose<VideosNotifier, List<File>>((ref) {
  return VideosNotifier(ref.watch(directoriesProvider)['videosDir']!);
});

final playlistsProvider = StateNotifierProvider.autoDispose<PlaylistsNotifier, List<Playlist>>((ref) {
  Map<String, String> dirs = ref.watch(directoriesProvider);

  return PlaylistsNotifier(dirs['playlistDir']!, dirs['songsDir']!);
});

final songsProvider = StateNotifierProvider.autoDispose<SongsNotifier, List<Song>>((ref) {
  return SongsNotifier(ref.watch(directoriesProvider)['songsDir']!);
});

final biblesProvider = StateNotifierProvider.autoDispose<BiblesNotifier, List<BibleData>>((ref) {
  return BiblesNotifier(ref.watch(directoriesProvider)['biblesDir']!);
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

  Song? editedSong = ref.read(editedSongProvider);

  if (editedSong != null) {
    return editedSong;
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

final playlistSelectedPreviewProvider = StateProvider.autoDispose<dynamic>((ref) {
  List<Song> songs = ref.watch(previewedPlaylistProvider.select((value) => value.songs));
  if (songs.isNotEmpty) {
    return songs.first;
  }

  return null;
});

/// Highlights songs after editing
final editedSongProvider = StateProvider.autoDispose<Song?>((ref) {
  return null;
});
