// TODO

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

String blackBackgroundFilePath = 'media/black.jpg';

List<String> importFileExtensions = ['cspb', 'cpss', 'mp4', 'mov', 'jpg', 'jpeg', 'png'];

Future<String> biblesDirectory() async {
  String appDir = await getApplicationSupportDirectory().then((value) => value.path);

  return p.join(appDir, 'bibles');
}

Future<String> songsDirectory() async {
  String appDir = await getApplicationSupportDirectory().then((value) => value.path);

  return p.join(appDir, 'songs');
}

Future<String> mediaDirectory() async {
  String appDir = await getApplicationSupportDirectory().then((value) => value.path);

  return p.join(appDir, 'media');
}
