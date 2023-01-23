import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart' as constants;
import '../../core/file_utils.dart';
import '../media_center_providers.dart';

class MediaCenterPhotosTab extends ConsumerWidget {
  const MediaCenterPhotosTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<File> files = ref.watch(photosProvider);

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
                return Image.file(files[index]);
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
                  allowedExtensions: constants.photoFileExtensions,
                );

                if (result == null) return;

                await FileUtils.importPhotos(FileUtils.filePickerResultToFile(result));

                //await ref.read(photosProvider.notifier).fetch();
              },
              child: const Text('Import'),
            ),
          ),
        ],
      ),
    );
  }
}
