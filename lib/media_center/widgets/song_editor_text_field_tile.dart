import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../tabs/songs_tab.dart';

class SongEditorTextFieldTile extends ConsumerWidget {
  const SongEditorTextFieldTile({super.key, required this.label, required this.controller, required this.index});

  final TextEditingController controller;
  final int index;
  final String label;

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
                ref.read(songEditorLyricsFieldProvider.notifier).setCursorLocation(
                      textFieldIndex: index,
                      cursorPos: controller.selection.baseOffset,
                    );
              },
              onChanged: (input) {
                ref.read(songEditorLyricsFieldProvider.notifier).setCursorLocation(
                      textFieldIndex: index,
                      cursorPos: controller.selection.baseOffset,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
