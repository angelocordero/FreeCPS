// TODO
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

String blackBackgroundFilePath = 'media/black.jpg';

Map<String, Color> catpuccinColorsSample = {
  'Verse 1': const Color(0xffdd7878),
  'Verse 2': const Color(0xffea76cb),
  'Chorus': const Color(0xff8839ef),
  'Chorus 2': const Color(0xff40a02b),
  'Pre Chorus': const Color(0xffe64553),
  'Pre Chorus 1': const Color(0xffe64553),
  'Pre Chorus 2': const Color(0xfffe640b),
  'Bridge': const Color(0xff04a5e5),
  'Tag': const Color(0xff7287fd),
  'Default': const Color(0xff40a02b),
};

enum SlideType {
  scripture,
  song,
}

List<String> videoFileExtensions = ['mp4', 'mov'];
List<String> photoFileExtensions = ['jpg', 'jpeg', 'png'];
String bibleFileExtenstion = 'cpsb';
String songFileExtension = 'cpss';
String playlistFileExtension = 'cpsp';

Future<String> appDirectory() async {
  return await getApplicationSupportDirectory().then((value) => value.path);
}

Future<String> biblesDirectory() async {
  return p.join(await appDirectory(), 'bibles');
}

Future<String> songsDirectory() async {
  return p.join(await mediaDirectory(), 'songs');
}

Future<String> mediaDirectory() async {
  return p.join(await appDirectory(), 'media');
}

Future<String> photosDirectory() async {
  return p.join(await mediaDirectory(), 'photos');
}

Future<String> photoThumbnailsDirectory() async {
  return p.join(await photosDirectory(), 'thumbnails');
}

Future<String> videosDirectory() async {
  return p.join(await mediaDirectory(), 'videos');
}

Future<String> playlistsDirectory() async {
  return p.join(await mediaDirectory(), 'playlists');
}

List<String> superscriptMap = [
  '\u2070',
  '\u00B9',
  '\u00B2',
  '\u00B3',
  '\u2074',
  '\u2075',
  '\u2076',
  '\u2077',
  '\u2078',
  '\u2079',
];
