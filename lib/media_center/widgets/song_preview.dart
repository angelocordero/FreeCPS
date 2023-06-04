import 'package:flutter/material.dart';

import '../../models/song_model.dart';

class SongPreview extends StatelessWidget {
  const SongPreview(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    List<Column> list = song.lyrics.entries.map((entry) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(entry.key),
          ),
          ...entry.value.map(
            (e) => Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return ListView(
      children: [
        Text('TITLE: ${song.title}'),
        const Divider(),
        Text('ARTIST: ${song.artist}'),
        const Divider(),
        ...list,
      ],
    );
  }
}
