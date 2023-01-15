import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';

import 'tabs/media_center_photos_tab.dart';
import 'tabs/media_center_videos_tab.dart';

final photosProvider = FutureProvider<List<FileSystemEntity>>((ref) async {
  String path = await photoThumbnailsDirectory();

  return Directory(path).list().where((event) => event is File).toList();
});

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
                const Expanded(
                  child: TabBarView(
                    children: [
                      MediaCenterPhotosTab(),
                      MediaCenterVideosTab(),
                      Center(
                        child: Text('Songs'),
                      ),
                      Center(
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
