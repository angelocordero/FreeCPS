// TODO
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

String blackBackgroundFilePath = 'media/black.jpg';

Map<String, Color> catpuccinColorsSample = {
  'Verse 1': const Color(0xffdd7878),
  'Verse 2': const Color(0xffea76cb),
  'Chorus': const Color(0xff8839ef),
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
  return p.join(await mediaDirectory(), 'photos', 'thumbnails');
}

Future<String> videosDirectory() async {
  return p.join(await mediaDirectory(), 'videos');
}
