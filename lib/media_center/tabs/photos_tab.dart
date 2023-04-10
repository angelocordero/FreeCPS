import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import '../../core/constants.dart';
import '../../core/file_utils.dart';
import '../../core/providers_declaration.dart';
import '../media_center_providers.dart';

class PhotosTab extends ConsumerWidget {
  const PhotosTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<File> photos = ref.watch(photosProvider);
    Set<String> selectedPhotos = ref.watch(selectedPhotoProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                mainAxisExtent: 200,
              ),
              itemBuilder: (context, index) {
                File photo = photos[index];
                String fileName = basename(photo.path);

                return GestureDetector(
                  onTap: () {
                    bool ctrlKey = ref.read(mediaCenterCtrlKeyNotifier);

                    if (!ctrlKey) {
                      ref.read(selectedPhotoProvider.notifier).state = {fileName};
                    } else {
                      ref.read(selectedPhotoProvider.notifier).update((state) => {...state, fileName});
                    }
                  },
                  child: Card(
                    shape: selectedPhotos.contains(fileName)
                        ? const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xff1e66f5),
                              width: 1.5,
                            ),
                          )
                        : null,
                    child: Image.file(
                      photo,
                      fit: BoxFit.cover,
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
                FileUtils.addMediaToPlaylist(selectedPhotos, ref.read(activePlaylistProvider));
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
                  allowedExtensions: photoFileExtensions,
                );

                if (result == null) return;

                await FileUtils.importPhotos(FileUtils.filePickerResultToFile(result));
              },
              child: const Text('Import'),
            ),
          ],
        ),
      ],
    );
  }
}
