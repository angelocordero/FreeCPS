import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/media_center/tabs/media_center_songs_tab.dart';

import '../../core/constants.dart';

class SongEditorTextFieldTile extends ConsumerWidget {
  const SongEditorTextFieldTile({super.key, required this.label, required this.controller, required this.index});

  final String label;
  final TextEditingController controller;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = catpuccinColorsSample[label] ?? Colors.blueGrey;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            color: color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(index.toString()),
                Text(label),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              textAlign: TextAlign.center,
              controller: controller,
              minLines: 5,
              maxLines: 10,
              onTap: () {
                ref.read(songEditorProvider.notifier).setCursorPosition(
                      fieldIndex: index,
                      cursorPos: controller.selection.baseOffset,
                    );
              },
              onTapOutside: (_) {
                ref.read(songEditorProvider.notifier).resetCursorPosition();
              },
            ),
          ),
        ],
      ),
    );
  }
}
