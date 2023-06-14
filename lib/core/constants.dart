import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

String blackBackgroundFilePath = 'media/black.jpg';

const String customIdAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

List<Color> colorsSample = [
  const Color(0xffdd7878),
  const Color(0xffea76cb),
  const Color(0xff8839ef),
  const Color(0xff40a02b),
  const Color(0xffe64553),
  const Color(0xffe64553),
  const Color(0xfffe640b),
  const Color(0xff04a5e5),
  const Color(0xff7287fd),
  const Color(0xff40a02b),
];

List<String> lyricsGroup = [
  'Verse 1',
  'Verse 2',
  'Chorus',
  'Chorus 2',
  'Pre Chorus',
  'Pre Chorus 1',
  'Pre Chorus 2',
  'Bridge',
  'Tag',
  'Default',
];

Map<String, Color> lyricsGroupsColors = Map.fromIterables(lyricsGroup, colorsSample);

TextStyle songSlideTextStyle = const TextStyle(
  fontFamily: 'LemonMilk',
  fontSize: 80,
  color: Colors.white,
);

TextStyle verseSlideTextStyle = const TextStyle(
  fontFamily: 'SegoeUI',
  fontSize: 80,
  color: Colors.white,
);

TextStyle refTextStyle = GoogleFonts.raleway(
  textStyle: const TextStyle(
    fontSize: 50,
    color: Colors.white,
  ),
);

double constantSlidePanelInitialWeight = 0.65;

List<String> videoFileExtensions = ['mp4', 'mov'];
List<String> photoFileExtensions = ['jpg', 'jpeg', 'png'];
List<String> bibleFileExtenstion = ['cpsb'];
List<String> songFileExtension = ['cpss'];
List<String> playlistFileExtension = ['cpsp'];

Future<String> appDirectory() async {
  return await getApplicationSupportDirectory().then((value) => value.path);
}

Future<String> biblesDirectory() async {
  return join(await appDirectory(), 'bibles');
}

Future<String> songsDirectory() async {
  return join(await mediaDirectory(), 'songs');
}

Future<String> mediaDirectory() async {
  return join(await appDirectory(), 'media');
}

Future<String> settingsFile() async {
  return join(await settingsDir(), 'settings.json');
}

Future<String> settingsDir() async {
  return join(await appDirectory(), 'settings');
}

Future<String> photosDirectory() async {
  return join(await mediaDirectory(), 'photos');
}

Future<String> photoThumbnailsDirectory() async {
  return join(await photosDirectory(), 'thumbnails');
}

Future<String> videoThumbnailsDirectory() async {
  return join(await videosDirectory(), 'thumbnails');
}

Future<String> videosDirectory() async {
  return join(await mediaDirectory(), 'videos');
}

Future<String> playlistsDirectory() async {
  return join(await mediaDirectory(), 'playlists');
}

Future<String> getPlaylistPath(String fileName) async {
  return join(await playlistsDirectory(), fileName);
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
