import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/media_center/tabs/bibles_tab.dart';

import 'media_center_providers.dart';
import 'tabs/photos_tab.dart';
import 'tabs/playlists_tab.dart';
import 'tabs/songs_tab.dart';
import 'tabs/videos_tab.dart';

class MediaCenter extends ConsumerWidget {
  const MediaCenter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.controlLeft) || event.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
          ref.read(mediaCenterCtrlKeyNotifier.notifier).state = true;
          return;
        }
        ref.read(mediaCenterCtrlKeyNotifier.notifier).state = false;
      },
      child: Padding(
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
                  ref.watch(mediaCenterCtrlKeyNotifier) ? Container() : Container(),
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
                        PlaylistsTab(),
                        PhotosTab(),
                        VideosTab(),
                        SongsTab(),
                        BiblesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
