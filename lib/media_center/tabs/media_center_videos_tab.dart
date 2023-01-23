import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart' as constants;
import '../../core/file_utils.dart';
import '../media_center_providers.dart';
import '../notifiers/media_center_videos_notifier.dart';

class MediaCenterVideosTab extends ConsumerWidget {
  const MediaCenterVideosTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<VideoData> files = ref.watch(videosProvider);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: files.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                mainAxisExtent: 200,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: Center(
                    child: Text(files[index].item2),
                  ),
                );
              },
            ),
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
      ),
    );
  }
}