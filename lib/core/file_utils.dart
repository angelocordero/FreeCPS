import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_compression/image_compression.dart';
import 'package:path/path.dart';

import 'constants.dart' as constants;
import 'package:path/path.dart' as p;

import 'constants.dart';

class FileUtils {
  static importBible() {}

  static importMedia(FilePickerResult? result) async {
    if (result == null) return;

    String dir = await constants.mediaDirectory();

    List<File> files = result.paths.map((path) => File(path!)).toList();

    for (File file in files) {
      // copy files and generate thumbnails

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

  static initializeDirectories() async {
    String mediaDir = await mediaDirectory();

    Directory('$mediaDir/thumbnails').create(recursive: true);
  }
}
