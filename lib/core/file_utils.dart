import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_compression/image_compression.dart';
import 'package:path/path.dart';

import '../models/playlist_model.dart';
import '../models/song_model.dart';
import 'bible_parser.dart';
import 'constants.dart';
import 'helper_functions.dart';

class FileUtils {
  static initializeDirectories() async {
    Directory(await photoThumbnailsDirectory()).create(recursive: true);
    Directory(await videoThumbnailsDirectory()).create(recursive: true);
    Directory(await songsDirectory()).create(recursive: false);
    Directory(await playlistsDirectory()).create(recursive: false);
    Directory(await biblesDirectory()).create(recursive: false);

    File(await settingsFile()).createSync(recursive: true);
  }

  static Future<void> importPhotos(List<File> files) async {
    String dir = await photosDirectory();

    for (File file in files) {
      String filePath = join(dir, basename(file.path));

      await file.copy(filePath);

      String thumbnailPath = join(dir, 'thumbnails', basename(file.path));

      final output = compress(
        ImageFileConfiguration(
          input: ImageFile(
            rawBytes: file.readAsBytesSync(),
            filePath: file.path,
          ),
          config: const Configuration(
            jpgQuality: 40,
            pngCompression: PngCompression.bestCompression,
          ),
        ),
      );

      File(thumbnailPath).writeAsBytesSync(output.rawBytes);
    }
  }

  //! TODO: make thumbnails
  static void importVideos(List<File> files) async {
    String dir = await videosDirectory();

    for (File file in files) {
      String filePath = join(dir, basename(file.path));

      await file.copy(filePath);
    }
  }

  static void importSongs(List<File> files) async {
    String dir = await songsDirectory();

    for (File file in files) {
      String filePath = join(dir, basename(file.path));

      await file.copy(filePath);
    }
  }

  static void importPlaylist(List<File> files) async {
    String dir = await playlistsDirectory();

    for (File file in files) {
      String filePath = join(dir, basename(file.path));

      await file.copy(filePath);
    }
  }

  static void importBibles(List<File> files) async {
    for (File file in files) {
      BibleParser(file.path).parse();
    }
  }

  static List<File> filePickerResultToFile(FilePickerResult results) {
    return results.paths.map((path) => File(path!)).toList();
  }

  static getVideoFilePath(String fileName) async {
    String dir = await videosDirectory();

    return join(dir, fileName);
  }

  static getPhotoFilePath(String fileName) async {
    String dir = await photosDirectory();

    return join(dir, fileName);
  }

  static Future<String> getPlaylistPath(String fileName) async {
    return join(await playlistsDirectory(), fileName);
  }

  static void savePlaylist(Playlist playlist) async {
    String filePath = await getPlaylistPath(playlist.fileName);

    try {
      File(filePath).writeAsStringSync(playlist.toJson());
    } catch (e) {
      //
    }
  }

  static void addMediaToPlaylist(Set<String> media, Playlist playlist) {
    Set<String> list = {...playlist.media, ...media};

    savePlaylist(playlist.copyWith(media: list.toList()));
  }

  static void addSongToPlaylist(Song song, Playlist playlist) {
    savePlaylist(playlist.copyWith(songs: [...playlist.songs, song]));
  }

  static void addNewPlaylist() async {
    String fileName = '$generateRandomID.cpsp';

    File(join(await playlistsDirectory(), fileName)).writeAsStringSync(Playlist.addNew(fileName).toJson());
  }

  static void saveSettings(Map<String, String> settings) async {
    File(await settingsFile()).writeAsStringSync(const JsonEncoder.withIndent(' ').convert(settings));
  }

  static void saveSong(Song song) async {
    String songPath = join(await songsDirectory(), song.fileName);

    File(songPath).writeAsStringSync(song.toJson());
  }

 
}
