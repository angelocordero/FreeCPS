import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:freecps/core/bible_parser.dart';
import 'package:image_compression/image_compression.dart';
import 'package:nanoid/nanoid.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';

import '../models/playlist_model.dart';
import '../models/song_model.dart';
import 'constants.dart' as constants;
import 'constants.dart';

class FileUtils {
  static initializeDirectories() async {
    Directory('${await photosDirectory()}/thumbnails').create(recursive: true);
    Directory('${await videosDirectory()}/thumbnails').create(recursive: true);
    Directory(await songsDirectory()).create(recursive: false);
    Directory(await playlistsDirectory()).create(recursive: false);
    Directory(await biblesDirectory()).create(recursive: false);
  }

  static Future<void> importPhotos(List<File> files) async {
    String dir = await constants.photosDirectory();

    for (File file in files) {
      String filePath = p.join(dir, basename(file.path));

      await file.copy(filePath);

      String thumbnailPath = p.join(dir, 'thumbnails', basename(file.path));

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
    String dir = await constants.videosDirectory();

    for (File file in files) {
      String filePath = p.join(dir, basename(file.path));

      await file.copy(filePath);
    }
  }

  static void importSongs(List<File> files) async {
    String dir = await constants.songsDirectory();

    for (File file in files) {
      String filePath = p.join(dir, basename(file.path));

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
    String dir = await constants.videosDirectory();

    return p.join(dir, fileName);
  }

  static Future<String> getPlaylistPath(String fileName) async {
    return p.join(await playlistsDirectory(), fileName);
  }

  static void savePlaylist(Playlist playlist) async {
    String filePath = await getPlaylistPath(playlist.fileName);

    try {
      File(filePath).writeAsStringSync(playlist.toJson());
    } catch (e) {
      //
    }
  }

  static void addMediaToPlaylist(Set<String> media, Playlist playlist) async {
    Set<String> list = {...playlist.media, ...media};

    savePlaylist(playlist.copyWith(media: list.toList()));
  }

  static void addSongToPlaylist(Song song, Playlist playlist) {
    savePlaylist(playlist.copyWith(songs: [...playlist.songs, song]));
  }

  static void addNewPlaylist() async {
    String fileName = '${customAlphabet(customIdAlphabet, 30)}.cpss';

    File(p.join(await playlistsDirectory(), fileName)).writeAsStringSync(Playlist.addNew(fileName).toJson());
  }
}
