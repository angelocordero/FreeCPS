import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:freecps/core/file_utils.dart';

import '../core/constants.dart' as constants;

class MediaCenter extends StatelessWidget {
  const MediaCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: DefaultTabController(
            length: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Media Center',
                      style: TextStyle(fontSize: 30),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const Divider(),
                const TabBar(
                  tabs: [
                    Tab(text: 'Photos'),
                    Tab(text: 'Videos'),
                    Tab(text: 'Songs'),
                    Tab(text: 'Bibles'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Center(
                            child: Text('Photos'),
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

                                FileUtils.importPhotos(FileUtils.filePickerResultToFile(result));

                              },
                              child: const Text('Import'),
                            ),
                          ),
                        ],
                      ),
                      Column(
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
                      ),
                      const Center(
                        child: Text('Songs'),
                      ),
                      const Center(
                        child: Text('Bible'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
