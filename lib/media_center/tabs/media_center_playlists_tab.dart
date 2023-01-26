import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers_declaration.dart';
import '../../models/playlist_model.dart';
import '../media_center_providers.dart';

class MediaCenterPlaylistsTab extends ConsumerWidget {
  const MediaCenterPlaylistsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Playlist> playlists = ref.watch(playlistsProvider);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: playlists.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                mainAxisExtent: 200,
              ),
              itemBuilder: (context, index) {
                String selectedFileName = ref.watch(selectedPlaylistProvider);
                Playlist playlist = playlists[index];

                return GestureDetector(
                  onTap: () {
                    ref.read(selectedPlaylistProvider.notifier).state = playlist.fileName;
                  },
                  child: Card(
                    shape: playlist.fileName == selectedFileName
                        ? const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xff1e66f5),
                              width: 1.5,
                            ),
                          )
                        : null,
                    child: Center(
                      child: Text(playlist.title),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  String fileName = ref.read(selectedPlaylistProvider);

                  try {
                    ref.read(activePlaylistProvider.notifier).select(fileName);
                    Navigator.pop(context);
                  } catch (e) {
                    //
                  }
                },
                child: const Text('Select'),
              ),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                onPressed: () async {},
                child: const Text('Import'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
