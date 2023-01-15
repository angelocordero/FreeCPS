import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart' as constants;
import '../../core/file_utils.dart';

class MediaCenterVideosTab extends StatelessWidget {
  const MediaCenterVideosTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Center(
          child: Text('Videos'),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: constants.videoFileExtensions,
              );

              if (result == null) return;

              FileUtils.importVideos(FileUtils.filePickerResultToFile(result));
            },
            child: const Text('Import'),
          ),
        ),
      ],
    );
  }
}
