import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import '../../core/constants.dart';
import '../../core/file_utils.dart';
import '../../core/providers_declaration.dart';
import '../media_center_providers.dart';

class VideosTab extends ConsumerWidget {
  const VideosTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<File> videos = ref.watch(videosProvider);
    Set<String> selectedVideos = ref.watch(selectedVideoProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              itemCount: videos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                mainAxisExtent: 200,
              ),
              itemBuilder: (context, index) {
                File video = videos[index];
                String fileName = basename(video.path);

                return GestureDetector(
                  onTap: () {
                    bool ctrlKey = ref.read(mediaCenterCtrlKeyNotifier);

                    if (!ctrlKey) {
                      ref.read(selectedVideoProvider.notifier).state = {fileName};
                    } else {
                      ref.read(selectedVideoProvider.notifier).update((state) => {...state, fileName});
                    }
                  },
                  child: Card(
                    shape: selectedVideos.contains(fileName)
                        ? const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xff1e66f5),
                              width: 1.5,
                            ),
                          )
                        : null,
                    child: Center(
                      child: Text(basename(video.path)),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                FileUtils.addMediaToPlaylist(selectedVideos, ref.read(activePlaylistProvider));
              },
              child: const Text('Add To Playlist'),
            ),
            const SizedBox(
              width: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: videoFileExtensions,
                );

                if (result == null) return;

                FileUtils.importVideos(FileUtils.filePickerResultToFile(result));
              },
              child: const Text('Import'),
            ),
          ],
        ),
      ],
    );
  }
}
