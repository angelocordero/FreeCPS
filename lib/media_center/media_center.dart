import 'package:flutter/material.dart';
import 'package:freecps/media_center/tabs/media_center_playlists_tab.dart';

import 'tabs/media_center_photos_tab.dart';
import 'tabs/media_center_videos_tab.dart';

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
            length: 5,
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
                    Tab(text: 'Playlists'),
                    Tab(text: 'Photos'),
                    Tab(text: 'Videos'),
                    Tab(text: 'Songs'),
                    Tab(text: 'Bibles'),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      MediaCenterPlaylistsTab(),
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