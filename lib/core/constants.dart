// TODO

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

String blackBackgroundFilePath = 'media/black.jpg';

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
  return p.join(await appDirectory(), 'songs');
}

Future<String> mediaDirectory() async {
  return p.join(await appDirectory(), 'media');
}

Future<String> photosDirectory() async {
  return p.join(await mediaDirectory(), 'photos');
}

Future<String> videosDirectory() async {
  return p.join(await mediaDirectory(), 'videos');
}
